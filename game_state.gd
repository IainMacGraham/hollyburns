extends Node
# CODE MADE BY CLAUDE: https://claude.ai/share/44f4d17a-49c0-46f3-86f2-e3b534911db8
# Spawn points
var spawn_id: String = "default"
# Player stats (expand as needed)
var player_health: int = 100
# Quest/story flags
var flags: Dictionary = {}
# Inventory (we'll expand this later)
var inventory: Array = []
var _npc_data: Dictionary = {}

func _ready() -> void:
	InventoryManager.clue_added.connect(on_clue_collected)

func _ensure_npc(npc_id: String) -> void:
	if not _npc_data.has(npc_id):
		_npc_data[npc_id] = { "suspicion": 0, "memories": [] }

func get_npc_suspicion(npc_id: String) -> int:
	_ensure_npc(npc_id)
	return _npc_data[npc_id]["suspicion"]

func change_npc_suspicion(npc_id: String, delta: int) -> void:
	_ensure_npc(npc_id)
	var current: int = _npc_data[npc_id]["suspicion"]
	_npc_data[npc_id]["suspicion"] = clamp(current + delta, 0, 3)

func get_npc_memories(npc_id: String) -> Array:
	_ensure_npc(npc_id)
	return _npc_data[npc_id]["memories"]

func add_npc_memory(npc_id: String, player_msg: String, npc_msg: String) -> void:
	_ensure_npc(npc_id)
	var entry := "Player asked: \"%s\" | You replied: \"%s\"" \
				% [player_msg.left(60), npc_msg.left(80)]
	var mems: Array = _npc_data[npc_id]["memories"]
	mems.append(entry)
	if mems.size() > MAX_MEMORIES:
		mems = mems.slice(mems.size() - MAX_MEMORIES)
	_npc_data[npc_id]["memories"] = mems

func on_clue_collected(clue: ClueData) -> void:
	if clue.is_key_clue:
		for npc_id in _npc_data.keys():
			change_npc_suspicion(npc_id, 1)
	if clue.id == "odd_apple":
		change_npc_suspicion("woody", 1)

# Start of player load shared function
const Player = preload("res://player.tscn")
const MAX_MEMORIES := 10

func spawn_player(scene_root: Node) -> Node:
	var player = Player.instantiate()
	scene_root.add_child(player)
	
	# Find correct spawn point
	print("Looking for spawn_id: ", spawn_id)
	var spawn_points = scene_root.get_tree().get_nodes_in_group("spawn_points")
	print("Found spawn points: ", spawn_points.size())
	for point in spawn_points:
		print("Checking point: ", point.name)
		if point.name == spawn_id:
			player.position = point.position
			print("Spawned at: ", point.position)
			break
	
	return player
#End of player load shared func

# Helper functions for flags
func set_flag(flag_name: String, value: bool = true):
	flags[flag_name] = value

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)
