extends CharacterBody2D

@export var speed: float = 200.0
@export var min_dash_speed = 250.0
@export var max_dash_speed = 450.0
@export var current_direction: PlayerDirection = PlayerDirection.DOWN
@export var machete_scene: PackedScene = preload("res://scenes/objects/scene_machete.tscn")

@onready var animated_sprite = $AnimatedSprite2D

var current_state: MovementState = MovementState.IDLE

var dash_started = false
var attack_started = false
var dash_time = 0.0
var dash_duration = 0.18
var dash_delay = 0.0
var dash_max_delay = 0.36

var damage_delay = 0.0
var damage_max_delay = 1.0
var was_damaged = false
var health = 6

var knockback := Vector2.ZERO
var knockback_decay := 900.0

var hit_stun := 0.0
var hit_stun_duration := 0.2

var knockback_strength := 320.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	var current_speed = speed
	
	current_state = MovementState.IDLE
	
	if health < 0:
		get_tree().quit()
	
	if was_damaged:
		damage_delay += delta
		if damage_delay > damage_max_delay:
			damage_delay = 0.0
			was_damaged = false
	
	if hit_stun > 0.0:
		hit_stun -= delta
	
	if Input.is_action_pressed("action") and !attack_started:
		slash()
	
	if !dash_started and !attack_started and hit_stun <= 0.0:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
			current_direction = PlayerDirection.RIGHT
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
			current_direction = PlayerDirection.LEFT
		if Input.is_action_pressed("move_down"):
			direction.y += 1
			current_direction = PlayerDirection.DOWN
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
			current_direction = PlayerDirection.UP
	
	if direction.length() > 0:
		direction = direction.normalized()
		current_state = MovementState.RUNNING
	
	if Input.is_action_just_pressed("dash_action") and !dash_started and !attack_started and dash_delay > dash_max_delay:
		dash_started = true
		dash_time = 0.0
		dash_delay = 0.0
		current_state = MovementState.DASHING
	
	if dash_started:
		dash_time += delta
		if dash_time <= dash_duration:
			var t = (sin(dash_time * (PI / dash_duration)) + 1.0) * 0.5
			current_speed = lerp(min_dash_speed, max_dash_speed, t)
			match current_direction:
				PlayerDirection.RIGHT:
					direction = Vector2.RIGHT
				PlayerDirection.LEFT:
					direction = Vector2.LEFT
				PlayerDirection.UP:
					direction = Vector2.UP
				PlayerDirection.DOWN:
					direction = Vector2.DOWN
		else:
			dash_started = false
			current_speed = speed
	elif dash_delay < dash_max_delay:
		dash_delay += delta
	
	var control = 1.0 if hit_stun <= 0.0 else 0.2
	velocity = direction * current_speed * control + knockback
	
	knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * delta)
	
	move_and_slide()

func apply_impulse(direction: Vector2) -> void:
	if was_damaged:
		return
	
	was_damaged = true
	hit_stun = hit_stun_duration
	dash_started = false
	
	if direction.length() < 0.1:
		direction = Vector2.RIGHT
	
	knockback = direction.normalized() * knockback_strength
	
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
