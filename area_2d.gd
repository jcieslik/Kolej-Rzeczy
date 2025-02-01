extends Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var character = CharacterBody2D
	modulate.a = 0
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("action")):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				print("siema object player ;)")
				modulate.a = 1

	if (len(get_overlapping_bodies()) == 1):
		modulate.a = 0
		
	
