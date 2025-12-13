# Machete.gd
extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var facing_direction: PlayerDirection = PlayerDirection.DOWN
var player: CharacterBody2D

func _ready():	
	player = get_parent().get_node("Obj_Mikol")
	set_collision_layer_value(32, true)
	set_collision_mask_value(1, true)
	collision_shape.set_deferred("disabled", true)

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
	collision_shape.set_deferred("disabled", false)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	player.attack_started = false
	collision_shape.set_deferred("disabled", true)
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(facing_direction)

enum PlayerDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
