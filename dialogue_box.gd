extends PanelContainer

# *** ALL THIS CODE IS GENERATED WITH CLAUDE

@onready var npc_label = $VBoxContainer/HBoxContainer/NPCLabel
@onready var player_input = $VBoxContainer/PlayerInput
@onready var send_button = $VBoxContainer/SendButton
@onready var close_button = $VBoxContainer/HBoxContainer/CloseButton

func _ready():
	hide()
	AIController.response_received.connect(_on_response)
	send_button.pressed.connect(_on_send)
	# ✅ ADDED: pressing Enter in the text field also sends
	player_input.text_submitted.connect(_on_text_submitted)
	close_button.pressed.connect(_close_from_player)

func _on_text_submitted(text: String):
	_on_send()

var _pending_greeting: String = "..."

func set_greeting(text: String) -> void:
	_pending_greeting = text

func open():
	show()
	player_input.call_deferred("grab_focus")

func close():
	hide()
	player_input.text = ""
	AIController.end_npc_chat()

func _on_send():
	var msg = player_input.text.strip_edges()
	if msg == "":
		return
	npc_label.text = "..."
	player_input.text = ""
	# ✅ ADDED: prevent sending while waiting for response
	player_input.editable = false
	AIController.send_message(msg)

func _on_response(text: String):
	npc_label.text = text
	# ✅ ADDED: re-enable input so player can respond
	player_input.editable = true
	player_input.text = ""
	player_input.grab_focus()
	
func _input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_close_from_player()
		get_viewport().set_input_as_handled()
		return
	 # ✅ FIXED: only block movement/chat when not typing
	if not player_input.has_focus():
		var blocked = ["move_left", "move_right", "move_up", "move_down", "chat"]
		for action in blocked:
			if event.is_action(action):
				get_viewport().set_input_as_handled()
				return

func _close_from_player():
	close()
	AIController.end_npc_chat()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		InventoryManager.toggle()
	
