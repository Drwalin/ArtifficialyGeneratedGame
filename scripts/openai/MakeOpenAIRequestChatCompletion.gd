@tool
extends EditorScript
class_name MakeOpenAIRequestChatCompletion;

var example_items : String = "";

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
	var args_armor = [
#		"Generate heavy armor gauntlets",
#		"Generate heavy armor helmet",
#		"Generate heavy armor boots",
#		"Generate heavy armor leggings",
#		"Generate heavy armor brestplate or chainmail",
#		"Generate light armor gloves",
#		"Generate light armor helmet or hood",
#		"Generate light armor boots",
#		"Generate light armor leggings",
#		"Generate light armor vest",
#		"Generate mage armor gloves",
#		"Generate mage armor cowl or hood",
#		"Generate mage armor sandals or boots",
#		"Generate mage armor leggings",
#		"Generate mage armor robe",
#		"Generate weak heavy armor gauntlets",
#		"Generate weak heavy armor helmet",
#		"Generate weak heavy armor boots",
#		"Generate weak heavy armor leggings",
#		"Generate weak heavy armor brestplate or chainmail",
#		"Generate weak light armor gloves",
#		"Generate weak light armor helmet or hood",
#		"Generate weak light armor boots",
#		"Generate weak light armor leggings",
#		"Generate weak light armor vest",
#		"Generate weak mage armor gloves",
#		"Generate weak mage armor cowl or hood",
#		"Generate weak mage armor sandals or boots",
#		"Generate weak mage armor leggings",
#		"Generate weak mage armor robe",
#		"Generate very powerfull heavy armor gauntlets",
#		"Generate very powerfull heavy armor helmet",
#		"Generate very powerfull heavy armor boots",
#		"Generate very powerfull heavy armor leggings",
#		"Generate very powerfull heavy armor brestplate or chainmail",
#		"Generate very powerfull light armor gloves",
#		"Generate very powerfull light armor helmet or hood",
#		"Generate very powerfull light armor boots",
#		"Generate very powerfull light armor leggings",
#		"Generate very powerfull light armor vest",
#		"Generate very powerfull mage armor gloves",
#		"Generate very powerfull mage armor cowl or hood",
#		"Generate very powerfull mage armor sandals or boots",
#		"Generate very powerfull mage armor leggings",
#		"Generate very powerfull mage armor robe",
#		"Generate legendary artifact heavy armor gauntlets",
#		"Generate legendary artifact heavy armor helmet",
#		"Generate legendary artifact heavy armor boots",
#		"Generate legendary artifact heavy armor leggings",
#		"Generate legendary artifact heavy armor brestplate or chainmail",
#		"Generate legendary artifact light armor gloves",
#		"Generate legendary artifact light armor helmet or hood",
#		"Generate legendary artifact light armor boots",
		"Generate legendary artifact light armor leggings",
		"Generate legendary artifact light armor vest",
		"Generate legendary artifact mage armor gloves",
		"Generate legendary artifact mage armor cowl or hood",
		"Generate legendary artifact mage armor sandals or boots",
		"Generate legendary artifact mage armor leggings",
		"Generate legendary artifact mage armor robe",
	];
	
	var args_weapon = [
		"Generate legendary artifact sword",
		"Generate legendary artifact two handed sword",
		"Generate legendary artifact staff",
		"Generate legendary artifact druid staff",
		"Generate legendary artifact leric staff",
		"Generate legendary artifact mage staff",
		"Generate legendary artifact mace",
		"Generate legendary artifact weapon",
		"Generate legendary artifact axe",
		"Generate legendary artifact waraxe",
		"Generate legendary artifact spear",
		"Generate legendary artifact whip",
		"Generate legendary artifact dagger",
		"Generate legendary artifact hammer",
		"Generate legendary artifact bow",
		"Generate legendary artifact crossbow",
		"Generate legendary artifact shield",
		"Generate sword",
		"Generate two handed sword",
		"Generate staff",
		"Generate druid staff",
		"Generate leric staff",
		"Generate mage staff",
		"Generate mace",
		"Generate weapon",
		"Generate axe",
		"Generate waraxe",
		"Generate spear",
		"Generate whip",
		"Generate dagger",
		"Generate hammer",
		"Generate bow",
		"Generate crossbow",
		"Generate shield",
#		"Generate weak sword",
#		"Generate weak two handed sword",
#		"Generate weak staff",
#		"Generate weak druid staff",
#		"Generate weak leric staff",
#		"Generate weak mage staff",
#		"Generate weak mace",
#		"Generate weak weapon",
#		"Generate weak axe",
#		"Generate weak waraxe",
#		"Generate weak spear",
#		"Generate weak whip",
#		"Generate weak dagger",
#		"Generate weak hammer",
#		"Generate weak bow",
#		"Generate weak crossbow",
#		"Generate weak shield",
		"Generate very powerfull sword",
		"Generate very powerfull two handed sword",
		"Generate very powerfull staff",
		"Generate very powerfull druid staff",
		"Generate very powerfull leric staff",
		"Generate very powerfull mage staff",
		"Generate very powerfull mace",
		"Generate very powerfull weapon",
		"Generate very powerfull axe",
		"Generate very powerfull waraxe",
		"Generate very powerfull spear",
		"Generate very powerfull whip",
		"Generate very powerfull dagger",
		"Generate very powerfull hammer",
		"Generate very powerfull bow",
		"Generate very powerfull crossbow",
		"Generate very powerfull shield",
	];
	
	var args_potion = [
		"Generate potion",
		"Generate not healing potion",
		"Generate not healing nor mana potion",
		"Generate magical food",
		"Generate non combat potion",
		"Generate legendary potion",
		"Generate not healing legendary potion",
		"Generate not healing nor mana legendary potion",
		"Generate legendary magical food",
		"Generate non combat legendary potion",
	];
	
	var args_other = [
		"Generate util",
		"Generate junk",
		"Generate trap",
	];
	
	var full_args = [
#		[
#			args_weapon,
#			"res://openai/generated_for_finetuning/Items-weapons.json",
#			200
#		],
#		[
#			args_potion,
#			"res://openai/generated_for_finetuning/Items-potions.json",
#			300
#		],
#		[
#			args_armor,
#			"res://openai/generated_for_finetuning/Items-armor.json",
#			100
#		],
		[
			args_potion,
			"res://openai/generated_for_finetuning/Items-potions.json",
			300
		],
		[
			args_weapon,
			"res://openai/generated_for_finetuning/Items-weapons.json",
			500
		],
		[	args_other,
			"res://openai/generated_for_finetuning/Empty.json",
			400
		]
	];
	
	
	for i in range(0,100):
		print("\n");
	for arg in full_args:
		for m in arg[0]:
			example_items = FileAccess.open(arg[1], FileAccess.READ).get_as_text();
			do_stuff(m, arg[2]);
			print("\n\n\nBefore sleep");
			OS.delay_msec(1000*20);
			print("\n\n\nAfter sleep");

func do_stuff(message: String, starting_file_id: int = 1):
	var callback = func(json):
		print(JSON.stringify(json, "\t"));
		if json.choices:
			pass;
		else:
			return;
		print("\n\n\n Separate responses for query '%s':\n\n" % [message]);
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
	CallChatAPIWithDefaultSystem(callback, "Generate ", "gpt-3.5-turbo-16k", 10, 1);

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
	
	for III in range(0, 3):
		var xhttp : HTTPClient = HTTPClient.new();
		xhttp.connect_to_host(hostname);
		print(xhttp.get_status());
		for i in range(0, 2000):
			OS.delay_msec(10);
			xhttp.poll();
			if xhttp.get_status() == 5:
				break;
			if i%500 == 0:
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
		if err == 0:
			var response:String = "";
			var received = 0;
			
			for i in range(0, 20000):
				OS.delay_msec(10);
				xhttp.poll();
				if i%500 == 0:
					print(i, " - ", xhttp.get_status());
				if xhttp.get_status() == xhttp.STATUS_BODY:
					if xhttp.has_response():
						var chunk = xhttp.read_response_body_chunk();
						received += chunk.size();
						response += chunk.get_string_from_utf8();
						if xhttp.get_response_body_length() == received:
							var json = JSON.parse_string(response);
							callback.call(json);
							var h = xhttp.get_response_headers_as_dictionary();
							print("\n\nHeaders: ", JSON.stringify(h, "\t"));
							return;
			OS.delay_msec(1000*60);
		else:
			OS.delay_msec(1000);
			



func generate_system_message() -> String:
	var items = example_items;
	var system_header = (FileAccess.open(
			"res://openai/item_format_description.txt",
			FileAccess.READ)
		.get_as_text());
	var output : String = system_header + "\n\nHere are some example items:\n\n" + items;
	return output;
