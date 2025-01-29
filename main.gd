extends Control


# Called when the node enters the scene tree for the first time.
var HOP_COUNT = 9

var GRAVITY = 0.5 # top_y = 0, bot_y > 0
var SPRITE_INIT_X
var SPRITE_INIT_Y
var PHANTOM_HOP_UPGRADE = 0
var HASKELL_COUNT = 1

var PHANTOM_HOP_PRICE = 10
var MAKE_FRIEND_PRICE = 15

#var JUMP
#var DIR
#var CURR_POS
#var VEL_Y
#var VEL_X
var SPRITE_DICT
var VEL_JUMP_Y = 9
var VEL_JUMP_X = 9


func _ready() -> void:
	print("LES GO")
	reset_var()	
	$HBoxUpgrade/PhantomHop.connect("pressed",Callable(self,"_phantom_hop").bind())
	$HBoxUpgrade/MakeFriend.connect("pressed",Callable(self,"_make_friend").bind())

	$HBoxUpgrade/PhantomHop.hide()
	$HBoxUpgrade/MakeFriend.hide()	
	get_viewport().connect("size_changed", reset_var)



func reset_var():
	for button in $BoxHop.get_children():
		if !button.is_connected("pressed", Callable(self,"_button_pressed").bind(button)):
			button.connect("pressed",Callable(self,"_button_pressed").bind(button))
	SPRITE_INIT_X = get_viewport_rect().size.x / 2
	SPRITE_INIT_Y = get_viewport_rect().size.y / 4
	
	SPRITE_DICT = {}
	#JUMP = []
	#VEL_X = []
	#VEL_Y = []
	#CURR_POS = []
	#DIR = []
	var ind = 0
	for sprite in $SpriteList.get_children():
		if !sprite.phantom:
			sprite.position.x = SPRITE_INIT_X
			sprite.position.y = SPRITE_INIT_Y
			#sprite.ind = ind
			

			sprite.button = $BoxHop.get_children()[ind]
			sprite.button.disabled = false
			sprite.button.sprite = sprite
			sprite.jump = false
			sprite.curr_pos = 1
			sprite.vel_x = 0
			sprite.vel_y = 0
			#JUMP.append(false)
			#CURR_POS.append(1)
			#VEL_X.append(0)
			#VEL_Y.append(0)
			#DIR.append(-1)
			
			if sprite.get_node("Sprite").flip_h:
				sprite.dir = 1
			else:
				sprite.dir = -1
			ind += 1
		
	#ind = 0
	#for button in $HBoxHop.get_children():
		#button.disabled = false
		#button.ind = ind
		#
		#
		#
		#ind += 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HopCount.text = "[center]"+str(HOP_COUNT)+"[/center]"
	if HOP_COUNT >= PHANTOM_HOP_PRICE or PHANTOM_HOP_UPGRADE > 0:
		$HBoxUpgrade/PhantomHop.show()
		var message
		
		if HASKELL_COUNT > PHANTOM_HOP_UPGRADE and HOP_COUNT >= PHANTOM_HOP_PRICE:
			$HBoxUpgrade/PhantomHop.disabled = false
			message = str(PHANTOM_HOP_PRICE) + " Hops"
		else:
			$HBoxUpgrade/PhantomHop.disabled = true
			message = "Not Enough Friends"
		$HBoxUpgrade/PhantomHop.text = "Phantom Hop\n" + message

	if HOP_COUNT >= MAKE_FRIEND_PRICE or HASKELL_COUNT > 1:
		$HBoxUpgrade/MakeFriend.show()
		var message = str(MAKE_FRIEND_PRICE) + " Hops"
		
		if HOP_COUNT >= MAKE_FRIEND_PRICE:
			$HBoxUpgrade/MakeFriend.disabled = false
		else:
			$HBoxUpgrade/MakeFriend.disabled = true
		
		$HBoxUpgrade/MakeFriend.text = "Make Friend\n" + message
	
	
	#var button_list = $HBoxHop.get_children()
	var ind = 0
	for sprite in $SpriteList.get_children():
		if sprite.position.y < SPRITE_INIT_Y:
			sprite.vel_y += GRAVITY
		
		sprite.position.x += sprite.vel_x
		sprite.position.y += sprite.vel_y
		
		if sprite.jump and sprite.position.y > SPRITE_INIT_Y:
			if !sprite.phantom:

				sprite.button.disabled = false
			sprite.jump = false
				
			sprite.position.y = SPRITE_INIT_Y
			sprite.vel_x = 0
			sprite.vel_y = 0
			sprite.curr_pos += sprite.dir
			
			if sprite.curr_pos == 0 or sprite.curr_pos == 2:
				sprite.dir = -sprite.dir
			

			if sprite.phantom:
				sprite.queue_free()
		ind += 1

func jump(sprite):

	HOP_COUNT += 1
	sprite.jump = true
	sprite.vel_y = -VEL_JUMP_Y
	sprite.vel_x = sprite.dir * VEL_JUMP_X

	#bug
	

	if !sprite.phantom and (sprite.curr_pos == 0 or sprite.curr_pos == 2):
		sprite.get_node("Sprite").flip_h = !sprite.get_node("Sprite").flip_h
		

func _button_pressed(button):

	if not button.sprite.jump:

		jump(button.sprite)
		button.disabled = true

func _phantom_hop():
	print("hi")
	PHANTOM_HOP_PRICE = floor(PHANTOM_HOP_PRICE * 1.5)
	#$HBoxHop.get_children()[AUTO_HOP_COUNT].hide()
	$SpriteList.get_children()[PHANTOM_HOP_UPGRADE].phantom_hop = true
	$SpriteList.get_children()[PHANTOM_HOP_UPGRADE]._on_timer_timeout()
	#JUMP[AUTO_HOP_COUNT] = true
	#jump($HBoxHop.get_children()[AUTO_HOP_COUNT])
	PHANTOM_HOP_UPGRADE += 1

func _make_friend():
	MAKE_FRIEND_PRICE = floor(MAKE_FRIEND_PRICE * 1.5)
	var friend = $SpriteList.get_children()[0].duplicate()
	friend.position.x = SPRITE_INIT_X
	friend.position.y = SPRITE_INIT_Y

	friend.get_node("Sprite").flip_h = false
	$SpriteList.add_child(friend)
	
	var friend_button = $BoxHop.get_children()[0].duplicate()

	friend_button.show()
	friend_button.disabled = false
	friend_button.sprite = friend
	$BoxHop.add_child(friend_button)
	friend_button.connect("pressed",Callable(self,"_button_pressed").bind(friend_button))
	
	friend.button = friend_button	
	
	HASKELL_COUNT += 1


	
	
