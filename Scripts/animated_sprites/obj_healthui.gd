extends AnimatedSprite2D
@onready var obj_mikol := get_node("../../..")

func _process(_delta: float) -> void:
	play(str(obj_mikol.health))
