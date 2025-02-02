extends Sprite2D


# Called when the node enters the scene tree for the first time.

var GRAVITY = 0.5
var VEL_Y = 0
var HEIGHT
var HOP_POWER = 0
var MAIN
# MAIN.get_node("
func _ready() -> void:
	MAIN = get_tree().get_root().get_node("BossBattle")
	HEIGHT = $Area2D/CollisionShape2D.shape.get_size().y
	var platform = MAIN.get_node("Platform")
	platform.position.x = position.x + platform.texture.get_width() * platform.scale.x / 2
	platform.position.y = get_viewport_rect().size.y / 2 + platform.texture.get_width() * platform.scale.x / 2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y > MAIN.get_node("Platform").position.y - MAIN.get_node("Platform").HEIGHT / 2 and not MAIN.get_node("Platform").MOVING_UP:
		position.y = MAIN.get_node("Platform").position.y - MAIN.get_node("Platform").HEIGHT / 2
		if VEL_Y > 1:
			HOP_POWER += VEL_Y * 0.75
		VEL_Y = 0
	elif MAIN.get_node("Platform").position.y > position.y + HEIGHT / 1.95:
		VEL_Y += GRAVITY
	position.y += VEL_Y
	position.y = clampf(position.y, HEIGHT / 2, get_viewport_rect().size.y)
	#print(HOP_POWER)
	MAIN.get_node("VBoxContainer/ProgressBar").value = HOP_POWER

func _on_area_2d_area_entered(area: Area2D) -> void:
	VEL_Y = 0

func _on_area_2d_area_exited(area: Area2D) -> void:
	VEL_Y = GRAVITY
