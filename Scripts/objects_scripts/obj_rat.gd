extends CharacterBody2D

@export var speed: float = 100.0
@export var push_force: float = 2000.0
@export var detection_range: float = 200.0
@export var iframe_duration: float = 0.5

var player = null
var lives = 2
var iframe = 0.0
var took_damage = false
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_area: Area2D = $DamageArea2D

enum PlayerDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _ready():
	player = get_tree().get_first_node_in_group("player")
	damage_area.body_entered.connect(_on_damage_area_body_entered)

func _physics_process(delta):
	if took_damage:
		iframe += delta
		velocity = knockback_velocity
		knockback_velocity *= 0.8

		if knockback_velocity.length() < 10:
			knockback_velocity = Vector2.ZERO

		if iframe >= iframe_duration:
			took_damage = false
			iframe = 0.0
	else:
		if player:
			var distance = global_position.distance_to(player.global_position)

			if distance <= detection_range:
				var direction = (player.global_position - global_position).normalized()
				velocity = direction * speed
			else:
				velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO

	move_and_slide()

	if lives < 1:
		queue_free()

func _on_damage_area_body_entered(body):
	if body == player:
		if not player.was_damaged:
			player.health -= 1
		
		var push_direction = (player.global_position - global_position).normalized()
		player.apply_impulse(push_direction * push_force)

func take_damage(attack_direction: PlayerDirection):
	if took_damage:
		return

	lives -= 1
	took_damage = true
	iframe = 0.0

	var knockback_force = 500.0
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

	knockback_velocity = -direction * knockback_force

	_flash_sprite()

func _flash_sprite() -> void:
	var flash_interval = 0.02
	var flashes = int(iframe_duration / flash_interval)

	for i in range(flashes):
		animated_sprite.visible = !animated_sprite.visible
		await get_tree().create_timer(flash_interval).timeout

	animated_sprite.visible = true
