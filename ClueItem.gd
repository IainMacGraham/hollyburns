# ui/ClueItem.gd
extends PanelContainer
# ALL CODE WRITTEN BY CLAUDE

@onready var title_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var desc_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Description
@onready var location_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Location

@onready var icon_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect

func setup(clue: ClueData) -> void:
	title_label.text = clue.title
	desc_label.text = clue.description
	location_label.text = "Found: " + clue.location_found
	if clue.icon:
		icon_rect.texture = clue.icon
