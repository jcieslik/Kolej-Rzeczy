extends Node2D

@export var target_level: String
@export var target_spawn: String = "start"

var player_inside := false

@onready var area: Area2D = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("action"):
		var main = get_tree().get_first_node_in_group("main")
		if main:
			main.load_level(target_level, target_spawn)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
