# res://resources/npc_data.gd
# CODE WRITTEN BY CLAUDE: https://claude.ai/share/44f4d17a-49c0-46f3-86f2-e3b534911db8
class_name NPCData
extends Resource

@export var npc_id: String = ""           # unique key e.g. "old_harold"
@export var display_name: String = ""
@export var portrait: Texture2D = null
@export var agent_name: String = ""

# AI personality — injected into the system prompt
@export_multiline var personality: String = ""
# e.g. "You are Harold, a gruff retired woodsman who has lived in Hollyburns
#  his whole life. You distrust outsiders and speak in short, blunt sentences.
#  You are hiding something about the night of the fire."

@export_multiline var background: String = ""
# Known facts the NPC always has access to (not secrets)

@export_multiline var secret: String = ""
# Only revealed when suspicion >= threshold; injected conditionally

@export var suspicion_reveal_threshold: int = 2
# 0=neutral 1=uneasy 2=suspicious 3=hostile
