# ALL CODE FROM CLAUDE:
# autoloads/InventoryManager.gd
extends Node

signal clue_added(clue: ClueData)
signal inventory_toggled(is_open: bool)

const TOTAL_CLUES = 5

var clues: Array[ClueData] = []
var is_open: bool = false

func add_clue(clue: ClueData) -> void:
	if has_clue(clue.id):
		return
	clues.append(clue)
	GameState.inventory.append(clue.id)
	clue_added.emit(clue)

func has_clue(id: String) -> bool:
	return clues.any(func(c): return c.id == id)

func toggle() -> void:
	is_open = !is_open
	inventory_toggled.emit(is_open)
