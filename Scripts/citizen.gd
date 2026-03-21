extends CharacterBody2D

@export var speed = 20
@export var moving = false
@export_file("*.json")
var dialogue_file: String

@onready var timer = $Timer


func _ready():
	timer.wait_time = 2.0
	timer.one_shot = false   # repeat forever
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _process(_delta: float) -> void:
	move_and_slide()
	# timer
	
# funkcja nie dziala nie widzi timera
func _on_timer_timeout() -> void:
	print("Timer finished!")
	var direction
	moving = !moving
	print(moving)
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
	
	velocity = direction * speed
