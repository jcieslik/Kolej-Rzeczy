extends CharacterBody2D

@export var speed: float = 200.0
@export var min_dash_speed = 250.0
@export var max_dash_speed = 450.0
@export var current_direction: PlayerDirection = PlayerDirection.DOWN

var current_state: MovementState = MovementState.IDLE

var dash_started = false
var dash_time = 0.0
var dash_duration = 0.18 # Duration of whole dash
var dash_delay = 0.0
var dash_max_delay = 0.36 # delay between dashes

var damage_delay = 0.0
var damage_max_delay = 0.5
var was_damaged = false

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	var current_speed = speed
	
	current_state = MovementState.IDLE
	
	if was_damaged and damage_delay < damage_max_delay: 
		damage_delay += delta
		
	if damage_delay > damage_max_delay:
		was_damaged = false

	if !dash_started: 	
		if Input.is_action_pressed("ui_right"):
			direction.x += 1 
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.RIGHT
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.LEFT
		if Input.is_action_pressed("ui_down"):
			direction.y += 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.DOWN
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1  
			current_state = MovementState.RUNNING
			current_direction = PlayerDirection.UP
		


	if direction.length() > 0:
		direction = direction.normalized()
		
	if Input.is_action_pressed("dash_action") and !dash_started and dash_delay > dash_max_delay:
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
		
	velocity = direction * current_speed
	
	move_and_slide()
	
func apply_impulse(force: Vector2) -> void: 
	if !was_damaged: 
		velocity += force
		was_damaged = true
		move_and_slide()

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
