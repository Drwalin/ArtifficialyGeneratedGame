@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var items = ResourceLoader.load("res://openai/generated_for_finetuning/Items.json") as JSON;
	#print(items.data);
	var system_header = FileAccess.open("res://openai/item_format_description.txt", FileAccess.READ).get_as_text();
	var output : String = "";
	for i in items.data:
		var json : JSON = JSON.new();
		var content = json.stringify(i, "\t") as String;
		var entry = {
			"messages": [
				{
					"role": "system",
					"content": system_header
				},
				{
					"role": "user",
					"content": "Generate random item."
				},
				{
					"role": "assistant",
					"content": content
				}
			]
		}
		var entryString = json.stringify(entry) as String;
		output += entryString + "\n";
	FileAccess.open("res://openai/fine_tuning/fine-tuning-items-1.json", FileAccess.WRITE).store_string(output);
