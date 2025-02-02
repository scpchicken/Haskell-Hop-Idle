extends Sprite2D

var VEL_X = 0
var VEL_Y = 0
var VEL_STORE_X = 0
var VEL_STORE_Y = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += Vector2(VEL_X, VEL_Y)
