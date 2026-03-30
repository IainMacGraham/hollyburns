extends Control

# ALL CODE WRITTEN BY CLAUDE: 

@onready var player_dot = $PanelContainer/VBoxContainer/MapContainer/PlayerDot
@onready var close_button = $PanelContainer/VBoxContainer/Header/HBoxContainer/CloseButton

const WORLD_ORIGIN = Vector2(-1870, -890)
const WORLD_SIZE = Vector2(2400, 1680)
const MAP_SIZE = Vector2(200, 152)  # match your minimap image size

var player: Node2D

func _ready() -> void:
	hide()
	close_button.pressed.connect(hide)
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if not visible or not player:
		return
	var normalized = (player.global_position - WORLD_ORIGIN) / WORLD_SIZE
	player_dot.position = normalized * MAP_SIZE

func open() -> void:
	player = get_tree().get_first_node_in_group("player")
	show()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map"):
		if visible:
			hide()
		else:
			open()
