extends CharacterBody2D

@export var speed: float = 100.0
@export var push_force: float = 2000.0
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance <= 200:
			var direction = (player.position - position).normalized()
			velocity = direction * speed * delta
			var collision = move_and_collide(velocity)
			if collision:
				var collider = collision.get_collider()
				if collider == player:
					var push_direction = (player.global_position - global_position).normalized()
					var applied = player.apply_impulse(push_direction * push_force)
		else:
			velocity = Vector2.ZERO
