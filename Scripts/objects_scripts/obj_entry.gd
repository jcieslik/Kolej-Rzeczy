extends Area2D

@export var target_level: String
@export var target_spawn: String = "start"

var player_inside := false
var player_ref: Node = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("action"):
		var main = get_tree().get_first_node_in_group("main")
		if main:
			main.load_level(target_level, target_spawn)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		player_ref = body

func _on_body_exited(body):
	if body == player_ref:
		player_inside = false
		player_ref = null
