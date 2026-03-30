extends CharacterBody2D

@export var speed: float = 120.0 #was 80
@onready var clue_indicator = $ClueIndicator

var interactables_in_range = []

func _ready():
	$CollisionShape2D.disabled = false
	#print("Looking for spawn_id: ", GameState.spawn_id)
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	#print("Found spawn points: ", spawn_points.size())
	clue_indicator.hide()
	for point in spawn_points:
		#print("Checking point: ", point.name)
		if point.name == GameState.spawn_id:
			position = point.position
			print("Spawned at: ", position)
			break

func _physics_process(delta):
	# Copied from Claude: block movement while dialog is open
	var dialog = get_node_or_null("/root/DialogueBox/DialogueBox")
	if dialog and dialog.visible:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		return
	
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1

	if input_dir.length() > 0:
		velocity = input_dir.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	# Animation direction
	if input_dir.x != 0:
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.flip_h = input_dir.x < 0
		$AnimatedSprite2D.flip_v = false
	elif input_dir.y < 0:
		$AnimatedSprite2D.animation = "walk_up"
	elif input_dir.y > 0:
		$AnimatedSprite2D.animation = "walk_down"

	move_and_slide()
	

func _input(event):
	if event.is_action_pressed("interact"):
		try_interact()

func try_interact():
	if interactables_in_range.size() > 0:
		interactables_in_range[0].interact()

func _on_interaction_area_area_entered(area):
	#print("Area entered: ", area.name)
	if area.has_method("interact"):
		#print("Has interact method!")
		interactables_in_range.append(area)
	if area is PickupClue:
		clue_indicator.show()

func _on_interaction_area_area_exited(area):
	interactables_in_range.erase(area)
	if area is PickupClue:
		clue_indicator.hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
