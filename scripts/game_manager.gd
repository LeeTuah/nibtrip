extends Node2D

# var cursor_arrow = load("res://assets/cursor/back/back20.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	$cursor/default.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$cursor.global_position = get_global_mouse_position();
