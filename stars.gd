# attach to stars node
extends Node2D
# Code written by Claude: https://claude.ai/share/44f4d17a-49c0-46f3-86f2-e3b534911db8

var star_data: Array = []

func _ready() -> void:
	randomize()
	for i in 30:
		star_data.append({
			"pos": Vector2(randf() * 320.0, randf() * 100.0),
			"brightness": randf_range(0.4, 1.0),
			"flicker": randf_range(0.8, 2.4)
		})

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var t := Time.get_ticks_msec() / 1000.0
	for star in star_data:
		var flicker: float = 0.6 + sin(t * star["flicker"] + star["pos"].x) * 0.4
		var alpha: float = star["brightness"] * flicker
		draw_rect(Rect2(star["pos"], Vector2(2, 2)), Color(1.0, 1.0, 0.9, alpha))
