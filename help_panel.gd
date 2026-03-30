# ui/HelpPanel.gd
extends Control

# ALL CODE FROM CLAUDE: https://claude.ai/share/4cd9c11e-aecd-4d70-a71f-23ce7740d526

@onready var panel = $PanelContainer
@onready var close_button = $PanelContainer/VBoxContainer/Header/HBoxContainer/Button

func _ready() -> void:
	hide()
	close_button.pressed.connect(hide)

func _on_help_button_pressed() -> void:
	show()
