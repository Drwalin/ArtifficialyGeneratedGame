@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var items = JSON.parse_string(FileAccess.open("res://openai/generated_for_finetuning/Items.json", FileAccess.READ).get_as_text());
	var system_header = (FileAccess.open(
			"res://openai/item_format_description.txt",
			FileAccess.READ)
		.get_as_text());
	var output : String = "";
	for i in items:
		print(i, "\n\n");
		var json = JSON;#: JSON = JSON.new();
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
	var file = FileAccess.open("res://openai/fine_tuning/fine-tuning-items-1.json", FileAccess.WRITE);
	file.store_string(output);
	file.close();
