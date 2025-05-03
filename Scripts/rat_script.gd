extends CharacterBody2D

@export var speed: float = 100.0
@export var push_force: float = 2000.0
var player = null
var lives = 2
var iframeDuration = 0.5
var iframe = 0.0
var took_damage = false
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D  # Referencing the AnimatedSprite2D node

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if took_damage: 
		iframe += delta
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity * 0.8
		if knockback_velocity.length() < 10:
			knockback_velocity = Vector2.ZERO
	else:
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
						player.apply_impulse(push_direction * push_force)

	if iframe >= iframeDuration:
		took_damage = false

	if lives < 1:
		queue_free()
			
func take_damage(attack_direction: PlayerDirection):
	if !took_damage:
		lives -= 1
		took_damage = true
		
		var push_force = 500
		var direction = Vector2.ZERO
		
		match attack_direction:
			PlayerDirection.UP:
				direction = Vector2(0, -1)
			PlayerDirection.DOWN:
				direction = Vector2(0, 1)
			PlayerDirection.LEFT:
				direction = Vector2(-1, 0)
			PlayerDirection.RIGHT:
				direction = Vector2(1, 0)
		
		velocity = direction * -push_force
		
		var flash_duration = iframeDuration
		var flash_interval = 0.02
		var flashes = flash_duration / flash_interval
		
		for i in range(flashes):
			animated_sprite.visible = !animated_sprite.visible
			await get_tree().create_timer(flash_interval).timeout
		
		animated_sprite.visible = true

enum PlayerDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
