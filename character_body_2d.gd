extends CharacterBody2D

@export var speed: float = 200.0 

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1  
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1  
	if Input.is_action_pressed("ui_down"):
			direction.y += 1  
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1  
		


	if direction.length() > 0:
		direction = direction.normalized()

	if Input.is_action_pressed("dash_action"):
			speed = 400  
	else:
			speed = 200  

	velocity = direction * speed
	move_and_slide()
	

	
	if get_slide_collision_count() > 0:
		velocity = Vector2.ZERO  # 
