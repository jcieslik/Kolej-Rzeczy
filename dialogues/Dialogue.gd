extends CanvasLayer

@export_file("*.json")
var dialogue_file: String

var dialogue = []
var current_dialogue_id = 0
var dialogue_active = false

func _ready():
	$TextureRect.visible = false
	start()
	
	$TextureRect/type.text = dialogue[0]["type"]
	$TextureRect/text.text = dialogue[0]["text"]
	
func start():
	if dialogue_active:
		return
	dialogue_active = true
	$TextureRect.visible = true
	dialogue = load_dialogue()
	
func load_dialogue():
	if FileAccess.file_exists(dialogue_file):
		var file = FileAccess.open(dialogue_file, FileAccess.READ)
		var text = file.get_as_text()
		file.close()
		return JSON.parse_string(text)
	return null
	
func _input(event):
	if not dialogue_active:
		return
	if event.is_action_pressed("action"):
		next_script()
		
func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id >= len(dialogue):
		dialogue_active = false
		$TextureRect.visible = false
		return
		
	$TextureRect/type.text = dialogue[current_dialogue_id]["type"]
	$TextureRect/text.text = dialogue[current_dialogue_id]["text"]
		
