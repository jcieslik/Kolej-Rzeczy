# Machete.gd
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing_direction: PlayerDirection = PlayerDirection.DOWN
var player: CharacterBody2D

func _ready():	
	player = get_parent().get_node("Obj_Mikol")

func set_direction(direction: PlayerDirection):
	facing_direction = direction
	
	match facing_direction:
		PlayerDirection.UP:
			rotation = deg_to_rad(180)
		PlayerDirection.DOWN:
			rotation = deg_to_rad(0)
		PlayerDirection.LEFT:
			rotation = deg_to_rad(90)
		PlayerDirection.RIGHT:
			rotation = deg_to_rad(270)

func play_animation():
	animated_sprite.play("slash")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	player.attack_started = false
	
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
