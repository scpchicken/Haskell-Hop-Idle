extends Button

#var ind
var sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	get_tree().get_root().get_node("Control").BUTTON_SELECT_BOOL = true
	get_tree().get_root().get_node("Control").BUTTON_SELECT = self


func _on_mouse_exited() -> void:
	get_tree().get_root().get_node("Control").BUTTON_SELECT_BOOL = false
	get_tree().get_root().get_node("Control").BUTTON_SELECT = null
