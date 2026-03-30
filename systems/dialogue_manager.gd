extends Node

signal dialogue_requested(npc_id)

func request_dialogue(npc_id):
	dialogue_requested.emit(npc_id)
