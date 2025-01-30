extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = get_viewport_rect().size.x / 2
	position.y = get_viewport_rect().size.y / 2



func _on_timer_timeout() -> void:
	$Timer.start()
	self.flip_h = !self.flip_h
