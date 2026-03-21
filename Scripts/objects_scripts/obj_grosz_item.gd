extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") && body.health < 99: 
		body.grosze += 10
		queue_free()
