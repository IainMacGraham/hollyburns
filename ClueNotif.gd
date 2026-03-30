# ui/ClueNotif.gd
extends PanelContainer
# All code written by Claude 

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	modulate.a = 0.0
	InventoryManager.clue_added.connect(_on_clue_added)

func _on_clue_added(clue: ClueData) -> void:
	label.text = '+ Clue: "%s"' % clue.title
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
