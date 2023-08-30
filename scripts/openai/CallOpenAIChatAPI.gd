@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var req = MakeOpenAIRequestChatCompletion.new();
	var callback = func(json):
		print(JSON.stringify(json));
	req.CallChatAPIWithDefaultSystem(callback, "Generate random item", "gpt-3.5-turbo", 2, 1);

