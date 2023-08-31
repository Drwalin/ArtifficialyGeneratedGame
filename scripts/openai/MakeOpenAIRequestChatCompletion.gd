@tool
extends EditorScript
class_name MakeOpenAIRequestChatCompletion;

func GetNewItemsFileName(starting_file_id: int = 1) -> String:
	for i in range(starting_file_id,100000):
		var path:String = "res://openai/generated_for_finetuning/Items%d.json" % [i];
		if FileAccess.file_exists(path) == false:
			return path;
	assert(false);
	return "";

func _run():
	var thread: Thread = Thread.new();
	thread.start(DoWork);
	thread.wait_to_finish();
	
func DoWork():
	var args = [
		"Generate heavy armor wear_hand",
		"Generate heavy armor wear_head",
		"Generate heavy armor wear_feet",
		"Generate heavy armor wear_legs",
		"Generate heavy armor wear_torso",
		
		"Generate light armor wear_hand",
		"Generate light armor wear_head",
		"Generate light armor wear_feet",
		"Generate light armor wear_legs",
		"Generate light armor wear_torso",
		
		"Generate mage armor wear_hand",
		"Generate mage armor wear_head",
		"Generate mage armor wear_feet",
		"Generate mage armor wear_legs",
		"Generate mage armor wear_torso",
		
		"Generate potion",
		"Generate not healing potion",
		"Generate not healing nor mana potion",
		"Generate artifact",
		"Generate legendary artifact",
		"Generate non combat potion",
		"Generate util",
		"Generate junk",
		"Generate magical food"
	];
	for i in range(0,100):
		print("\n");
	for m in args:
		do_stuff(m, 20);
		print("\n\n\nBefore sleep");
		OS.delay_msec(1000*30);
		print("\n\n\nAfter sleep");
		break;

func do_stuff(message: String, starting_file_id: int = 1):
	var callback = func(json):
		print(JSON.stringify(json, "\t"));
		print("\n\n\n Separate responses:\n\n");
		var file_content = "[";
		var first = true;
		for c in json.choices:
			if first:
				first = false;
			else:
				file_content += ",";
			file_content += "\n";
			print("\n\n\n");
			print(c.message.content);
			file_content += c.message.content;
		print("\n\n\n");
		file_content += "\n]\n";
		var file_path = GetNewItemsFileName(starting_file_id);
		print("Saving into file: ", file_path);
		var resps = FileAccess.open(file_path, FileAccess.WRITE);
		resps.store_string(file_content);
	CallChatAPIWithDefaultSystem(callback, "Generate ", "gpt-3.5-turbo-16k", 30, 1);

func CallChatAPIWithDefaultSystem(callback, message:String,
		model:String="gpt-3.5-turbo", n: int=1, temperature: float=1,
		presence_penalty:float=0, frequency_penalty:float=0):
	var key = OS.get_environment("OPENAI_API_KEY");
	var system_message = generate_system_message();
	var body = {
		"model": model,
		"messages": [
			{
				"role": "system",
				"content": system_message
			},
			{
				"role": "user",
				"content": message
			}
		],
		"temperature": temperature,
		"presence_penalty": presence_penalty,
		"frequency_penalty": frequency_penalty,
		"n": n
	};
	
	#var fullurl = "https://api.openai.com/v1/chat/completions";
	var hostname = "https://api.openai.com";
	var endpoint:String = "/v1/chat/completions";
	var xhttp : HTTPClient = HTTPClient.new();
	xhttp.connect_to_host(hostname);
	print(xhttp.get_status());
	for i in range(0, 1300001):
		xhttp.poll();
		if xhttp.get_status() == 5:
			break;
		if i%100000 == 0:
			print(i, " - ", xhttp.get_status());
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + key
	];
	
	var data_to_send = JSON.stringify(body);
	
	print("Sending system message:\n", system_message, "\n\n\n\n\n");
	print("data_to_send length: ", data_to_send.length(), "\n\n");
	var err = xhttp.request(HTTPClient.METHOD_POST, endpoint, headers, data_to_send);
	print("Request error: ", err);
	if err != 0:
		return;
	
	var response:String = "";
	var received = 0;
	
	for i in range(0, 10000000000):
		xhttp.poll();
		if i%1000000 == 0:
			print(i, " - ", xhttp.get_status());
		if xhttp.get_status() == xhttp.STATUS_BODY:
			if xhttp.has_response():
				var chunk = xhttp.read_response_body_chunk();
				received += chunk.size();
				response += chunk.get_string_from_utf8();
				if xhttp.get_response_body_length() == received:
					break;
	var json = JSON.parse_string(response);
	callback.call(json);
	

func generate_system_message() -> String:
	var items = JSON.parse_string(FileAccess.open("res://openai/generated_for_finetuning/Items2.json", FileAccess.READ).get_as_text());
	var system_header = (FileAccess.open(
			"res://openai/item_format_description.txt",
			FileAccess.READ)
		.get_as_text());
	var output : String = system_header;
#	return output;
	
	output += "\n\nHere are some example items:";
	for i in items:
		var content:String = JSON.stringify(i, "\t") as String;
		output = output + "\n\n" + content;
	return output;
