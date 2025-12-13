extends CharacterBody2D

@export var speed = 80
@export var moving = false
@export_file("*.json")
var dialogue_file: String


func _process(_delta: float) -> void:
	move_and_slide()
	

# funkcja nie dziala nie widzi timera
func _on_timer_timeout() -> void:
	var direction
	moving = !moving
	print(moving)
	if moving:
		var rand = randi()%8
		match rand:
			0: direction = Vector2( 1, 0)
			1: direction = Vector2( 1, 1)
			2: direction = Vector2( 0, 1)
			3: direction = Vector2(-1, 1)
			4: direction = Vector2(-1, 0)
			5: direction = Vector2(-1,-1)
			6: direction = Vector2( 0,-1)
			7: direction = Vector2( 1, 1)		
	else:
		direction = Vector2(0, 0)
	
	velocity = direction * speed
