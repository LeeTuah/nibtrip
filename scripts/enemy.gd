extends RigidBody2D

const SCALE_RESIZE_MULTIPLIER :float = 1.0

@onready var enemy_sprite = $Sprite2D
var is_falling:bool = false
var is_dead:bool = false

func _ready() -> void:
	pass


func pen_falling() -> void:
	is_falling = true
	

func folk_dead() -> void:
	is_dead = true
	queue_free()

func _process(delta: float) -> void:
	if not is_falling:
		pass
		
	else:
		var scale_decrement = delta * SCALE_RESIZE_MULTIPLIER
		enemy_sprite.scale -= Vector2(scale_decrement, scale_decrement)
		enemy_sprite.scale = enemy_sprite.scale.clamp(Vector2.ZERO, Vector2(1000, 1000))
		
		if enemy_sprite.scale == Vector2(0.00001, 0.00001):	
			folk_dead()
	
