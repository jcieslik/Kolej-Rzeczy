extends Area2D

func _input(event):
	if event.is_action_pressed("action"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				use_dialogue()
		
func use_dialogue():
	var dialogue = get_parent().get_node("Dialogue")
	
	if dialogue:
		dialogue.start()
