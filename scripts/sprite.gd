extends MarginContainer

#var ind
var phantom = false
var phantom_hop = false
var started = false
var jump = false
var vel_x = 0
var vel_y = 0
var curr_pos = 1
var dir = -1
var button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if phantom_hop and !started:
		started = true
		$Timer.start()
		

func _on_timer_timeout() -> void:
	started = false
	var phantom_friend = self.duplicate()
	phantom_friend.curr_pos = self.curr_pos

	phantom_friend.modulate.a = 0.5
	phantom_friend.phantom = true
	get_tree().get_root().get_node("Control/SpriteList").add_child(phantom_friend)
	
	
	if phantom_friend.curr_pos == 0:
		phantom_friend.dir = 1
		phantom_friend.get_node("Sprite").flip_h = true
	elif phantom_friend.curr_pos == 2:
		phantom_friend.dir = -1
		phantom_friend.get_node("Sprite").flip_h = false
	elif phantom_friend.curr_pos == 1 and phantom_friend.jump:
		phantom_friend.dir = -phantom_friend.dir
		phantom_friend.get_node("Sprite").flip_h = !phantom_friend.get_node("Sprite").flip_h
	else:
		phantom_friend.dir = self.dir
		phantom_friend.get_node("Sprite").flip_h = self.get_node("Sprite").flip_h

	
	get_tree().get_root().get_node("Control").jump(phantom_friend)

	$Timer.start()
