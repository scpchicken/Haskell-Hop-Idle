extends Sprite2D

var VEL_Y = 0
var VEL_MOVE = 25
var MOVING_UP = false
var HEIGHT
var SHOOT = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HEIGHT = $Area2D/CollisionShape2D.shape.get_size().y
	get_tree().get_root().get_node("BossBattle/Player").position.x = position.x
	get_tree().get_root().get_node("BossBattle/Player").position.y = position.y - HEIGHT / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var dir = 0
	
	if get_tree().get_root().get_node("BossBattle/ColorRect").SHOOT_BOOL == false:
		if Input.is_key_pressed(KEY_W):
			dir -= 1
			
		if Input.is_key_pressed(KEY_S):
			dir += 1
		
		
	VEL_Y = VEL_MOVE * dir
	#print(VEL_Y)
	position.y += VEL_Y
	position.y = clampf(position.y, get_tree().get_root().get_node("BossBattle/Player").HEIGHT * 1.1, get_viewport_rect().size.y - $Area2D/CollisionShape2D.shape.get_size().y / 4)
	MOVING_UP = dir == 1
	
		
