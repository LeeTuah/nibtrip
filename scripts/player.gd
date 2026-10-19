extends RigidBody2D

const IMPULSE_MULTIPLIER : float = 3.0
const MAX_IMPULSE : float = 400.0

var left_mb_down :bool = false
var left_mb_held_down_timer: float = 0.0;

var mouse_in_drag_region :bool = false
var drag_start_coords :Vector2
var drag_end_coords :Vector2

var apply_impulse_on_the_rigid_body = false;


func shake_trail_particles():
	var shake = Vector2.ZERO;
	var shake_mod = clampf(left_mb_held_down_timer / 10.0, 0.0, 1.5);

	shake.x = randf_range(-shake_mod, shake_mod);
	shake.y = randf_range(-shake_mod, shake_mod);

	return shake;


func _ready() -> void:
	pass
	
	
func clamp_vector(impulse_vect:Vector2) -> Vector2:
	var impulse_vect_mod:float = impulse_vect.length()
	
	if impulse_vect_mod > MAX_IMPULSE: # clamping impulse
		return (MAX_IMPULSE / impulse_vect_mod) * impulse_vect
		
	return impulse_vect


func _physics_process(_delta: float) -> void:	
	
	if apply_impulse_on_the_rigid_body:
		var drag_vector = drag_start_coords - drag_end_coords # drag direction vector
		var impulse_vector = clamp_vector(drag_vector * IMPULSE_MULTIPLIER)
		
		#impulse er point of application er position vector
		var impulse_origin = drag_start_coords - global_position
		
		apply_impulse_on_the_rigid_body = false; 
		apply_impulse(impulse_vector, impulse_origin)


func _process(delta: float) -> void:
	$trail_particles.visible = left_mb_down;
	get_tree().current_scene.get_node("cursor/default").visible = not left_mb_down;
	get_tree().current_scene.get_node("cursor/grab").visible = left_mb_down;

	if Input.is_action_just_pressed("ui_left_click") and mouse_in_drag_region:
		left_mb_down = true # tracks mouse starting position
		drag_start_coords = get_global_mouse_position()

	if left_mb_down:
		left_mb_held_down_timer += delta;

		$trail_particles/big_folk.global_position = drag_start_coords + shake_trail_particles();
		$trail_particles/small_folk.global_position = get_global_mouse_position() + shake_trail_particles();
		$trail_particles/mid_folk.global_position = ($trail_particles/big_folk.global_position + $trail_particles/small_folk.global_position) / 2.0 + shake_trail_particles();

		if Input.is_action_just_released("ui_left_click"):
			left_mb_down = false # tracks mouse ending position
			drag_end_coords = get_global_mouse_position()
			left_mb_held_down_timer = 0.0;

			apply_impulse_on_the_rigid_body = true;
		


func _on_drag_region_mouse_entered() -> void:
	if not left_mb_down:
		mouse_in_drag_region = true


func _on_drag_region_mouse_exited() -> void:
	mouse_in_drag_region = false
