extends CharacterBody2D

@onready var timer = $Timer

@export_file("*.json")
var dialogue_file: String

@export var speed = 20
@export var moving = false
var current_state: MovementState = MovementState.IDLE


func _ready():
	timer.wait_time = 2.0
	timer.one_shot = false   # repeat forever
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _process(_delta: float) -> void:
	move_and_slide()
	
# funkcja nie dziala nie widzi timera
func _on_timer_timeout() -> void:
	var direction
	moving = !moving
	if moving:
		var rand = randi()%8
		match rand:
			0: direction = Vector2( 1, 0)
			1: direction = Vector2( 1, 1)
			2: direction = Vector2( 0, 1)
			3: direction = Vector2(-1, 1)
			4: direction = Vector2(-1, 0)
			5: direction = Vector2(-1,-1)
			6: direction = Vector2( 0,-1)
			7: direction = Vector2( 1, 1)		
	else:
		direction = Vector2(0, 0)
		
	if direction.length() > 0:
		direction = direction.normalized()
		current_state = MovementState.CRAWLING
		if direction.x < 0:
			current_direction = OlsztyniakDirection.LEFT
		elif direction.x > 0:
			current_direction = OlsztyniakDirection.RIGHT
	else:
		current_state = MovementState.IDLE
	
	velocity = direction * speed
	
enum MovementState {
	IDLE,
	CRAWLING
}

enum OlsztyniakDirection {
	LEFT,
	RIGHT
}

var current_direction: OlsztyniakDirection = OlsztyniakDirection.RIGHT
