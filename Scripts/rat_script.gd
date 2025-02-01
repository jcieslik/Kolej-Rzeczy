extends CharacterBody2D

@export var speed: float = 100.0
@export var push_force: float = 2000.0
var player = null

var stop = 0.0
var can_move = true

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if !can_move && stop < 0.1:
		stop += delta
	
	if stop > 0.1:
		stop = 0.0
		can_move = true
		
	if player and can_move:
		var distance = global_position.distance_to(player.global_position)
				
		if distance <= 100:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			print(velocity)
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)	
				print(collision)
				var collider = collision.get_collider()
				if collider == player:
					var push_direction = (player.global_position - global_position).normalized()
					player.apply_impulse(push_direction * push_force)
					can_move = false
			move_and_slide()
		else:
			velocity = Vector2.ZERO
