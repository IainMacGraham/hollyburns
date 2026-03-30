extends Area2D


func _ready():
	pass

func interact():
	print("Door interact called!")
	get_parent().interact()
