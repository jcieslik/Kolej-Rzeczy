extends Control

@onready var label: Label = $Label
var player: Node = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if player:
		label.text = str(player.grosze) + " gr."
