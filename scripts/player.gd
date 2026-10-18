extends RigidBody2D

const IMPULSE_MULTIPLIER : float = 3.0
const MAX_IMPULSE : float = 400.0

var left_mb_down :bool = false
var mouse_in_drag_region :bool = false
var drag_start_coords :Vector2
var drag_end_coords :Vector2

func _ready() -> void:
	pass
	
	
func clamp_vector(impulse_vect:Vector2) -> Vector2:
	var resulting_vector:Vector2
	var impulse_vect_mod:float = sqrt(impulse_vect.x ** 2 + impulse_vect.y ** 2)
	
	if impulse_vect_mod > MAX_IMPULSE:
		resulting_vector = (MAX_IMPULSE / impulse_vect_mod) * impulse_vect
		return resulting_vector
		
	return impulse_vect


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_left_click") and mouse_in_drag_region:
		left_mb_down = true
		drag_start_coords = get_global_mouse_position()
		
	elif Input.is_action_just_released("ui_left_click") and left_mb_down:
		left_mb_down = false
		drag_end_coords = get_global_mouse_position()
		
		#drag er direction vector
		var drag_vector = drag_start_coords - drag_end_coords
		var impulse_vector = drag_vector * IMPULSE_MULTIPLIER
		impulse_vector = clamp_vector(impulse_vector)
		
		#impulse er point of application er position vector
		var impulse_origin = drag_start_coords - global_position
		
		apply_impulse(impulse_vector, impulse_origin)


func _on_drag_region_mouse_entered() -> void:
	if not left_mb_down:
		mouse_in_drag_region = true


func _on_drag_region_mouse_exited() -> void:
	mouse_in_drag_region = false
