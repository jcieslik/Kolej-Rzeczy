extends CharacterBody2D

@export var speed: float = 200.0
@export var min_dash_speed = 250.0
@export var max_dash_speed = 450.0
@export var current_direction: PlayerDirection = PlayerDirection.DOWN
@export var machete_scene: PackedScene = preload("res://scenes/scene_machete.tscn")

@onready var animated_sprite = $AnimatedSprite2D  # Referencing the AnimatedSprite2D node
var current_state: MovementState = MovementState.IDLE

var dash_started = false
var attack_started = false
var dash_time = 0.0
var dash_duration = 0.18
var dash_delay = 0.0
var dash_max_delay = 0.36 # delay between dashes

var damage_delay = 0.0
var damage_max_delay = 1.0
var was_damaged = false
var health = 6
		
func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	var current_speed = speed
	
	current_state = MovementState.IDLE
	
	if health < 0:
		get_tree().quit()
	
	if was_damaged and damage_delay < damage_max_delay: 
		damage_delay += delta
		
	if damage_delay > damage_max_delay:
		damage_delay = 0.0
		was_damaged = false
	
	if Input.is_action_pressed("action") and !attack_started: 
		slash()
	
	if !dash_started and !attack_started: 	
		if Input.is_action_pressed("move_right"):
			direction.x += 1 
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.RIGHT
		if Input.is_action_pressed("move_left"):
			direction.x -= 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.LEFT
		if Input.is_action_pressed("move_down"):
			direction.y += 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.DOWN
		if Input.is_action_pressed("move_up"):
			direction.y -= 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.UP
		


	if direction.length() > 0:
		direction = direction.normalized()
		
	if Input.is_action_pressed("dash_action") and !dash_started and !attack_started and dash_delay > dash_max_delay:
		current_state = MovementState.DASHING
		dash_time = 0.0
		dash_delay = 0.0
		dash_started = true
		

	if dash_started:
		dash_time += delta

		if dash_time <= dash_duration:
			var sine_factor = (sin(dash_time * (PI / dash_duration)) + 1) / 2
			current_speed = lerp(min_dash_speed, max_dash_speed, sine_factor) 
			if current_direction == PlayerDirection.RIGHT:
				direction.x = 1 
			if current_direction == PlayerDirection.LEFT:
				direction.x = -1  
			if current_direction == PlayerDirection.UP:
				direction.y = -1  
			if current_direction == PlayerDirection.DOWN:
				direction.y = 1  
		else:
			dash_started = false
			current_speed = speed
	elif dash_delay < dash_max_delay:
		dash_delay += delta
		
	velocity = direction * current_speed * delta
	
	move_and_collide(velocity)
	
func apply_impulse(force: Vector2) -> void: 
	if !was_damaged: 
		velocity += force
		was_damaged = true
		move_and_slide()
		
		var flash_duration = damage_max_delay
		var flash_interval = 0.02
		var flashes = flash_duration / flash_interval
		
		for i in range(flashes):
			animated_sprite.visible = !animated_sprite.visible
			await get_tree().create_timer(flash_interval).timeout
			
		animated_sprite.visible = true
		
func slash():
	attack_started = true
	
	var machete = machete_scene.instantiate()
	get_parent().add_child(machete)
	
	machete.global_position = global_position + get_facing_offset(current_direction)
	
	machete.set_direction(current_direction)
	
	machete.visible = true
	machete.play_animation()
	
func get_facing_offset(direction: PlayerDirection) -> Vector2:
	match direction:
		PlayerDirection.RIGHT:
			return Vector2(24, 0)  
		PlayerDirection.LEFT:
			return Vector2(-24, 0)
		PlayerDirection.UP:
			return Vector2(0, -24)
		PlayerDirection.DOWN:
			return Vector2(0, 24)
	return Vector2.ZERO

enum MovementState {
	IDLE,	
	RUNNING,
	DASHING
}

enum PlayerDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
