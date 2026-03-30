#npc.gd
extends CharacterBody2D

# USING A LOT OF CODE FROM A YOUTUBE TUTORIAL: https://www.youtube.com/watch?v=LMSbPkNgnWA 
# And Claude here and there. 

@export var npc_id: String
@export var agent_name: String   
@export var greeting: String = "Hey, what's up?"

const speed = 30
var currentState = IDLE 
var dir = Vector2.RIGHT
var startPos
var isRoaming = true
var isChatting = false
var player
var playerInChatZone = false
var maxWanderDistance: float = 32.0  # add this

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	startPos = position

func begin_chat() -> void:
	var box = get_node("/root/DialogueBox/DialogueBox")
	box.npc_label.text = "[" + npc_id + "]: " + greeting
	box.open()

func _process(delta):
	if currentState == 0 or currentState == 1:
		$AnimatedSprite2D.play("idle")
	elif currentState == 2 and !isChatting:
		if abs(dir.x) > abs(dir.y):
			if dir.x < 0:
				$AnimatedSprite2D.play("walk_west")
			else:
				$AnimatedSprite2D.play("walk_east")
		else:
			if dir.y < 0:
				$AnimatedSprite2D.play("walk_north")
			else:
				$AnimatedSprite2D.play("walk_south")
	if isRoaming:
		match currentState:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move()
	# Below if statement is modified by Claude:
	if Input.is_action_just_pressed("chat"):
		if Input.is_action_just_pressed("chat"):
			if playerInChatZone and !isChatting:
				isRoaming = false
				isChatting = true
				$AnimatedSprite2D.play("idle")
				AIController.start_npc_chat(self)
	
func choose(array):
	array.shuffle()
	return array.front()
	
func move():
	if !isChatting:
		if position.distance_to(startPos) > maxWanderDistance:
			# Too far from home — turn back
			dir = (startPos - position).normalized()
		velocity = dir * speed
		move_and_slide()

signal interacted(npc_id) #from ChatGPT

func interact(): #from ChatGPT
	emit_signal("interacted", npc_id)

func _on_chat_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		playerInChatZone = true


func _on_chat_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerInChatZone = false


func _on_timer_timeout() -> void:
	$Timer.wait_time	 = choose([0.5, 1, 1.5])
	# ✅ ADDED: don't change state while chatting
	if !isChatting:
		match currentState:
			IDLE:
				$Timer.wait_time = choose([0.5, 1.0, 1.5])
				currentState = choose([NEW_DIR, MOVE])
			NEW_DIR:
				$Timer.wait_time = choose([1.5, 2.0, 2.5])
				currentState = MOVE
			MOVE:
				$Timer.wait_time = choose([0.5, 1.0, 1.5])
				currentState = IDLE
		
# CODE BELOW FROM NEW CLAUDE CONVO: https://claude.ai/share/44f4d17a-49c0-46f3-86f2-e3b534911db8
func get_context_prefix() -> String:
	var suspicion := GameState.get_npc_suspicion(npc_id)
	var memories := GameState.get_npc_memories(npc_id)
	var mood: String = ["neutral", "uneasy", "suspicious", "hostile"][clamp(suspicion, 0, 3)]
	var prefix := "[SYSTEM CONTEXT — do not repeat this aloud]\n"
	prefix += "Your current mood toward this player: %s\n" % mood
	if memories.size() > 0:
		prefix += "What you remember from past conversations with this player:\n"
		for m in memories:
			prefix += "  - %s\n" % m
	prefix += "[END CONTEXT]\n\n"
	return prefix

func end_chat() -> void:
	isChatting = false
	isRoaming = true

func record_memory(player_msg: String, npc_msg: String) -> void:
	GameState.add_npc_memory(npc_id, player_msg, npc_msg)
	print("Memory stored for %s: " % npc_id, GameState.get_npc_memories(npc_id))
