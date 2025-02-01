extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	if Input.is_action_pressed("ui_down"):
		play("move_down")
	if Input.is_action_pressed("ui_up"):
		play("move_up")
		
	if not Input.is_action_pressed("ui_down") && not Input.is_action_pressed("ui_up") && not Input.is_action_pressed("ui_left") && not Input.is_action_pressed("ui_right"):
		stop() 
