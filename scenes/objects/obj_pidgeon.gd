extends CharacterBody2D

@export var fear_range: float = 150.0
@export var speed: float = 300.0
@export var despawn_range: float = 500.0
enum State { NIELOT, LOT } 
var player = null
var current_state = State.NIELOT
var start = false
var start_pos: Vector2

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	start_pos = global_position
	animated_sprite.play("pidgeon_idle")
	
func _physics_process(delta):
	match current_state:
		State.NIELOT:
			nielot_state()
		State.LOT:
			lot_state(delta)
			
	move_and_slide()
	
func nielot_state():
	if player and not start:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= fear_range:
			current_state = State.LOT
			start = true
			animated_sprite.play("pidgeon_fly")
			
			var fly_direction = Vector2(1, -1).normalized()
			velocity = fly_direction * speed
			velocity = fly_direction * speed
	

func lot_state(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player >= despawn_range:
		queue_free()
