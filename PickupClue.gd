# world/PickupClue.gd
class_name PickupClue
extends Area2D

# All code written by Claude

@export var clue_data: ClueData

func _ready() -> void:
	if clue_data and InventoryManager.has_clue(clue_data.id):
		queue_free()

func interact() -> void:
	if clue_data:
		InventoryManager.add_clue(clue_data)
		queue_free()
