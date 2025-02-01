extends Sprite2D

@onready var timer = $Timer 
var fade_speed: float = 0.1  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start() 
	
func _process(delta: float) -> void:
	modulate.a = 0.0

	if modulate.a <= 0.0:
		queue_free()  
