extends CanvasLayer

@export_file("*.json")
var dialogue_file: String

var dialogue = []

func _ready():
	start()
	
func start():
	dialogue = load_dialogue()
	$TextureRect/type.text = dialogue[0]["type"]
	$TextureRect/text.text = dialogue[0]["text"]
	
func load_dialogue():
	if FileAccess.file_exists(dialogue_file):
		var file = FileAccess.open(dialogue_file, FileAccess.READ)
		var text = file.get_as_text()
		file.close()
		return JSON.parse_string(text)
	return null
