extends Sprite2D

var ANGLE = 2 * PI
var LOOK_DIR = ANGLE
var TIMER_COUNT = 0
var ROTATION_SPEED = 0.3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = get_viewport_rect().size.x
	position.y = get_viewport_rect().size.y / 2
	$Timer.start()
	$TimerNull.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(to_global(to_local(get_global_mouse_position()).rotated(PI)))
	#print(position - 50)
	#look_at(to_global(to_local(get_global_mouse_position()).rotated(PI)))
	var currentRotation = rotation
	#// The rotation that should be interpolated towards (in radians)
	var targetRotation = Vector2(0,LOOK_DIR).angle()
	#// Set the rotation to an interpolated value.
	rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
	

func _on_timer_timeout() -> void:
	$Timer.start()
	if TIMER_COUNT % 2 == 0:
		LOOK_DIR = -ANGLE
	else:
		LOOK_DIR = ANGLE
	TIMER_COUNT += 1


func _on_timer_null_timeout() -> void:
	if get_tree().get_root().get_node("BossBattle/ColorRect").GAME_START and get_tree().get_root().get_node("BossBattle/ColorRect").SHOOT_BOOL == false and get_tree().get_root().get_node("BossBattle/ColorRect").WIN == false:
		$TimerNull.wait_time = randf_range(1.5, 2)
		$TimerNull.start()
		var null_sprite = get_tree().get_root().get_node("BossBattle/Null").duplicate()
		get_tree().get_root().get_node("BossBattle").add_child(null_sprite)
		null_sprite.z_index = 10
		null_sprite.position = self.position
		null_sprite.position.x -= self.texture.get_size().x / 2
		print(null_sprite.position)
		null_sprite.VEL_Y = sin(rotation) * 3
		null_sprite.VEL_STORE_Y = null_sprite.VEL_Y
		null_sprite.VEL_X = -cos(rotation) * 3
		null_sprite.VEL_STORE_X = null_sprite.VEL_X
