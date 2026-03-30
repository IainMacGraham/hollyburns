# res://title_screen.gd
extends Control
# ALL CODE WRITTEN BY CLAUDE: https://claude.ai/share/44f4d17a-49c0-46f3-86f2-e3b534911db8

# ── Config ────────────────────────────────────────────────────────────────────
const INTRO_TEXT = """[color=#a8c8a0]You've been coming to Camp Hollyburn since you were twelve.

Last summer was your fifth year. You came home missing a work boot — just the one. [color=#c8a870]"How does someone lose one boot?"[/color] your mum kept asking.

You couldn't really answer. The last few weeks of camp are... foggy. But you felt good about it. Weirdly, inexplicably good.

Before packing up you found a note in your journal — your own handwriting:
[color=#c8d870][i]"There's something going on here..."[/i][/color]

You spent the winter thinking about that note. About the boot. About the fog.

This summer you're coming back — not as a camper. As second-year property staff. Now is the time to have a proper look around.

[color=#ffffff]You're going to find out what's going on at Camp Hollyburn.[/color][/color]"""

const SCROLL_SPEED: float = 8.0   # pixels per second
const SCROLL_DELAY: float = 4    # seconds before scroll starts

# ── Parchment / camp palette ──────────────────────────────────────────────────
const COL_PANEL_BG     := Color(0.05, 0.14, 0.06, 0.92)
const COL_PANEL_BORDER := Color(0.18, 0.42, 0.12, 1.0)
const COL_BTN_NORMAL   := Color(0.08, 0.22, 0.09, 1.0)
const COL_BTN_HOVER    := Color(0.14, 0.36, 0.14, 1.0)
const COL_BTN_PRESSED  := Color(0.04, 0.12, 0.05, 1.0)
const COL_BTN_FONT     := Color(0.72, 0.92, 0.62, 1.0)
const COL_BTN_BORDER   := Color(0.28, 0.58, 0.22, 1.0)

# ── Nodes ─────────────────────────────────────────────────────────────────────
@onready var intro_scroll : RichTextLabel = $introPanel/introScroll
@onready var intro_panel  : Panel = $introPanel
@onready var start_btn    : Button = $buttonContainer/start
@onready var settings_btn : Button = $buttonContainer/settings
@onready var credits_btn  : Button = $buttonContainer/credits
@onready var cabin_light  : PointLight2D = $worldEffects/cabinLight
@onready var stars_node   : Node2D = $worldEffects/stars
@onready var reset_btn: Button = $introPanel/resetScroll

var _scroll_active : bool = false
var _scroll_timer  : float = 0.0
var _scroll_offset : float = 0.0
var _star_data     : Array = []

# ── Ready ─────────────────────────────────────────────────────────────────────
func _ready() -> void:
	_setup_intro()
	_setup_buttons()
	_connect_buttons()
	reset_btn.pressed.connect(_on_reset_scroll)
	DialogueBox.hide()
	
	# Fade in
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.2)

func _setup_intro() -> void:
	intro_scroll.bbcode_enabled = true
	intro_scroll.text = INTRO_TEXT
	intro_scroll.scroll_active = false
	# Style the panel
	var style := StyleBoxFlat.new()
	style.bg_color = COL_PANEL_BG
	style.border_color = COL_PANEL_BORDER
	style.set_border_width_all(1)
	style.set_content_margin_all(4)
	intro_panel.add_theme_stylebox_override("panel", style)
	intro_scroll.add_theme_font_size_override("normal_font_size", 8)
	intro_scroll.add_theme_font_size_override("bold_font_size", 8)
	intro_scroll.add_theme_font_size_override("italics_font_size", 8)
	intro_scroll.add_theme_font_size_override("bold_italics_font_size", 8)
	intro_scroll.size.x = 300

func _setup_buttons() -> void:
	for btn in [start_btn, settings_btn, credits_btn]:
		_style_button(btn)
	start_btn.text    = "START"
	settings_btn.text = "SETTINGS"
	credits_btn.text  = "CREDITS"
	_style_button(reset_btn)
	reset_btn.text = "↺"
	reset_btn.custom_minimum_size = Vector2(12, 12)
	reset_btn.add_theme_font_size_override("font_size", 10)

func _style_button(btn: Button) -> void:
	# Normal
	var normal := StyleBoxFlat.new()
	normal.bg_color = COL_BTN_NORMAL
	normal.border_color = COL_BTN_BORDER
	normal.set_border_width_all(1)
	normal.set_content_margin_all(2)
	# Hover
	var hover := StyleBoxFlat.new()
	hover.bg_color = COL_BTN_HOVER
	hover.border_color = COL_BTN_BORDER
	hover.set_border_width_all(1)
	hover.set_content_margin_all(2)
	# Pressed
	var pressed := StyleBoxFlat.new()
	pressed.bg_color = COL_BTN_PRESSED
	pressed.border_color = COL_BTN_BORDER
	pressed.set_border_width_all(1)
	pressed.set_content_margin_all(2)
	
	btn.add_theme_stylebox_override("normal",  normal)
	btn.add_theme_stylebox_override("hover",   hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_color_override("font_color", COL_BTN_FONT)
	btn.add_theme_font_size_override("font_size", 7)
	btn.custom_minimum_size = Vector2(60, 10)

func _connect_buttons() -> void:
	start_btn.pressed.connect(_on_start)
	settings_btn.pressed.connect(_on_settings)
	credits_btn.pressed.connect(_on_credits)
	
func _on_reset_scroll() -> void:
	_scroll_offset = 0.0
	_scroll_timer = 0.0
	intro_scroll.position.y = 0.0

# ── Process ───────────────────────────────────────────────────────────────────
func _process(delta: float) -> void:
	_tick_scroll(delta)
	queue_redraw()   # redraw stars each frame for flicker

func _tick_scroll(delta: float) -> void:
	_scroll_timer += delta
	if _scroll_timer < SCROLL_DELAY:
		return
	_scroll_active = true
	_scroll_offset += SCROLL_SPEED * delta
	# Clamp so it doesn't scroll forever
	var max_scroll := maxf(0.0, intro_scroll.get_content_height() - intro_panel.size.y)
	_scroll_offset = minf(_scroll_offset, max_scroll)
	intro_scroll.scroll_to_line(0)
	intro_scroll.position.y = -_scroll_offset

# ── Button handlers ───────────────────────────────────────────────────────────
func _on_start() -> void:
	DialogueBox.show()
	GameState.spawn_id = "default"
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.8)
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://world.tscn")
	)

func _on_settings() -> void:
	# Hook up to your settings panel when ready
	pass

func _on_credits() -> void:
	# Hook up to a credits screen when ready
	pass
