extends StaticBody2D

#CODE IS COPIED FROM CLAUDE https://claude.ai/share/395a280d-0e10-4b3a-a2c6-407e0bda9075

@export_file("*.scn", "*.tscn") var destination_scene: String = ""
@export var spawn_id: String = "default"
var is_open = false

func _ready():
	$AnimatedSprite2D.play("idle") 

func interact():
	print("interact called, is_open: ", is_open, " spawn_id: ", spawn_id)
	if not is_open:
		open()

func open():
	print("open called")
	is_open = true
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	print("animation finished, destination: ", destination_scene)
	if destination_scene != "":
		# Save where to spawn in the destination
		GameState.spawn_id = spawn_id
		get_tree().change_scene_to_file(destination_scene)

func close():
	is_open = false
	$AnimatedSprite2D.play("close")
	$CollisionShape2D.set_deferred("disabled", false)
