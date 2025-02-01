extends CharacterBody2D

@export var speed: float = 100.0
@export var push_force: float = 2000.0
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance <= 100:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)	
				var collider = collision.get_collider()
				if collider == player:
					var push_direction = (player.global_position - global_position).normalized()
					player.apply_impulse(push_direction * push_force)
		else:
			velocity = Vector2.ZERO
