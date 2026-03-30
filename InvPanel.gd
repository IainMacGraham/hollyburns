# ui/InvPanel.gd
extends Control
# ALL CODE WRITTEN BY CLAUDE

@onready var panel = $PanelContainer
@onready var clues_list = $PanelContainer/VBoxContainer/ScrollContainer/CluesList
@onready var close_button = $PanelContainer/VBoxContainer/Header/HeaderRow/CloseButton
@onready var empty_prompt = $PanelContainer/VBoxContainer/EmptyPrompt
@onready var clues_label = $PanelContainer/VBoxContainer/Header/HeaderRow/CLUES

const ClueItemScene = preload("res://ClueItem.tscn")

func _ready() -> void:
	hide()
	close_button.pressed.connect(InventoryManager.toggle)
	InventoryManager.inventory_toggled.connect(_on_toggled)
	InventoryManager.clue_added.connect(_on_clue_added)

func _on_toggled(open: bool) -> void:
	if open:
		_rebuild()
		show()
		modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate:a", 1.0, 0.15)
	else:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "modulate:a", 0.0, 0.1)
		tween.tween_callback(hide)

func _rebuild() -> void:
	#print("rebuilding, clue count: ", InventoryManager.clues.size())
	for child in clues_list.get_children():
		child.queue_free()
	for clue in InventoryManager.clues:
		var item = ClueItemScene.instantiate()
		clues_list.add_child(item)
		#print("added item, calling setup with: ", clue.title)
		#print("item size: ", item.size)
		item.setup(clue)
	empty_prompt.visible = InventoryManager.clues.is_empty()
	clues_label.text = "CLUES %d/%d" % [InventoryManager.clues.size(), InventoryManager.TOTAL_CLUES]

func _on_clue_added(_clue: ClueData) -> void:
	if visible:
		_rebuild()
