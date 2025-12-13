extends AnimatedSprite2D
@onready var obj_mikol := get_node("../../..")

func _process(_delta: float) -> void:
	
	print(obj_mikol.health)
	
	play(str(obj_mikol.health))
