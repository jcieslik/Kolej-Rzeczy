extends AnimatedSprite2D

enum PlayerDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum MovementState {
	IDLE,
	RUNNING,
	DASHING
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	var parent = get_parent()
	
	
	if parent.current_direction == PlayerDirection.DOWN:
		if parent.current_state == MovementState.RUNNING:
			play("move_down")
		else:
			play("idle_down")
		
	if parent.current_direction == PlayerDirection.UP:
		if parent.current_state == MovementState.RUNNING:
			play("move_up")
		else:
			play("idle_up")
		
	if parent.current_direction == PlayerDirection.LEFT:
		if parent.current_state == MovementState.RUNNING:
			play("move_left")
		else:
			play("idle_left")
		
	if parent.current_direction == PlayerDirection.RIGHT:
		if parent.current_state == MovementState.RUNNING:
			play("move_right")
		else:
			play("idle_right")
