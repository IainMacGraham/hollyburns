extends Node2D

func _ready():
#	for npc in $NPCContainer.get_children():
#		npc.interacted.connect(_on_npc_interacted)
	pass

func _on_npc_interacted(npc_id):
	DialogueManager.request_dialogue(npc_id)
