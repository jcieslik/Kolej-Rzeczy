extends Area2D

@onready var dialogue = get_parent().get_node("Dialogue")

func _input(event):
	if event.is_action_pressed("action") and dialogue.textureRect.visible:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				use_dialogue()
		
func use_dialogue():
	
	if dialogue:
		dialogue.start()
