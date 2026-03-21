extends Node2D

@onready var level_container = $LevelContainer
@onready var player = $Player

var current_level: Node = null

func _ready():
	load_level("res://scenes/levels/scene_dworzec.tscn", "start")

func load_level(path: String, spawn_name: String):
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited

	var level_scene = load(path)
	current_level = level_scene.instantiate()

	level_container.add_child(current_level)

	var spawn = current_level.get_node_or_null("SpawnPoints/" + spawn_name)
	if spawn:
		player.global_position = spawn.global_position
