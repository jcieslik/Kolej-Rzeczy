extends AnimatedSprite2D

enum OlsztyniakDirection {
	LEFT,
	RIGHT
}

enum MovementState {
	IDLE,
	CRAWLING
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var parent = get_parent()
	
	if parent.current_direction == OlsztyniakDirection.LEFT:
		if parent.current_state == MovementState.CRAWLING:
			play("olsztyniak_left")
		else:
			play("olsztyniak_idle_left")
		
	if parent.current_direction == OlsztyniakDirection.RIGHT:
		if parent.current_state == MovementState.CRAWLING:
			play("olsztyniak_right")
		else:
			play("olsztyniak_idle_right")

		
