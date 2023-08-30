@tool
extends EditorScript
class_name MakeOpenAIRequestChatCompletion;

func GetNewItemsFileName() -> String:
	for i in range(1,100000):
		var path:String = "res://openai/generated_for_finetuning/Items%d.json" % [i];
		if FileAccess.file_exists("res://openaio/") == false:
			return path;
	assert(false);
	return "";

func _run():
	var callback = func(json):
		print(JSON.stringify(json, "\t"));
		print("\n\n\n Separate responses:\n\n");
		var file_content = "[";
		var first = true;
		for c in json.choices:
			if first:
				pass;
			else:
				file_content += ",";
			file_content += "\n";
			print("\n\n\n");
			var str = JSON.stringify(JSON.parse_string(c.message.content), "\t");
			print(str);
			file_content += str;
		print("\n\n\n");
		file_content += "\n]\n";
		var resps = FileAccess.open(GetNewItemsFileName(), FileAccess.WRITE);
		resps.store_string(file_content);
	CallChatAPIWithDefaultSystem(callback, "Generate random item", "gpt-3.5-turbo-16k", 20, 1);

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
	
	var fullurl = "https://api.openai.com/v1/chat/completions";
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
	
#	var on_request_complete_callback = func(result, response_code, headers, body):
#		var json = JSON.parse_string(body.get_string_from_utf8());
#		callback.call(json);
#	xhttp.request_completed.connect(on_request_complete_callback);
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + key
	];
	
	var data_to_send = JSON.stringify(body);
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
		if xhttp.has_response():
			print("\nHAS RESPONSE!!!");
			var chunk = xhttp.read_response_body_chunk();
			received += chunk.size();
			response += chunk.get_string_from_utf8();
			if xhttp.get_response_body_length() == received:
				break;
	var json = JSON.parse_string(response);
	callback.call(json);
	

func generate_system_message() -> String:
	var items = JSON.parse_string(FileAccess.open("res://openai/generated_for_finetuning/Items.json", FileAccess.READ).get_as_text());
	var system_header = (FileAccess.open(
			"res://openai/item_format_description.txt",
			FileAccess.READ)
		.get_as_text());
	var output : String = system_header;
	for i in items:
		var content:String = JSON.stringify(i, "\t") as String;
		output = output + "\n\n" + content;
	return output;
