extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = get_viewport_rect().size.x - get_parent().get_node("Boss").texture.get_size().x
	position.y = get_viewport_rect().size.y / 2 - get_parent().get_node("Boss").texture.get_size().y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
