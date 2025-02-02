extends Control


# Called when the node enters the scene tree for the first time.
var HOP_COUNT = 0

var GRAVITY = 0.5 # top_y = 0, bot_y > 0
var SPRITE_INIT_X
var SPRITE_INIT_Y
var PHANTOM_HOP_UPGRADE = 0
var HASKELL_COUNT = 1
var QWERTY_HOP = false
var BOSS_BATTLE = false

var PHANTOM_HOP_PRICE = 10
var MAKE_FRIEND_PRICE = 69
var QWERTY_HOP_PRICE = 420

# make it harder to unlock later
var BOSS_BATTLE_PRICE = 1000

var QWERTY_VEC = [KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0,KEY_Q,KEY_W,KEY_E,KEY_R,KEY_T,KEY_Y,KEY_U,KEY_I,KEY_O,KEY_P,KEY_A,KEY_S,KEY_D,KEY_F,KEY_G,KEY_H,KEY_J,KEY_K,KEY_L,KEY_Z,KEY_X,KEY_C,KEY_V,KEY_B,KEY_N,KEY_M]

var BUTTON_SELECT
var BUTTON_SELECT_BOOL = false

#var JUMP
#var DIR
#var CURR_POS
#var VEL_Y
#var VEL_X
var VEL_JUMP_Y = 9
var VEL_JUMP_X = 9

var MAIN
# MAIN.get_node("

	
func _ready() -> void:
	MAIN = get_tree().get_root().get_node("BossBattle")
	print("LES GO")
	reset_var()	
	$HBoxUpgrade/PhantomHop.connect("button_down",Callable(self,"_phantom_hop").bind())
	$HBoxUpgrade/MakeFriend.connect("button_down",Callable(self,"_make_friend").bind())
	$HBoxUpgrade/QWERTYHop.connect("button_down",Callable(self,"_qwerty_hop").bind())
	$HBoxUpgrade/BossBattle.connect("button_down",Callable(self,"_boss_battle").bind())

	$HBoxUpgrade/PhantomHop.hide()
	$HBoxUpgrade/MakeFriend.hide()
	$HBoxUpgrade/QWERTYHop.hide()
	$HBoxUpgrade/BossBattle.hide()
	$Tip.hide()
	get_viewport().connect("size_changed", reset_var)



func reset_var():
	for button in $BoxHop.get_children():
		if !button.is_connected("button_down", Callable(self,"_button_pressed").bind(button)):
			button.connect("button_down", Callable(self,"_button_pressed").bind(button))
			
	SPRITE_INIT_X = get_viewport_rect().size.x / 2
	SPRITE_INIT_Y = get_viewport_rect().size.y / 4
	
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
			
			if sprite.get_node("Sprite").flip_h:
				sprite.dir = 1
			else:
				sprite.dir = -1
			ind += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("click"):
		if BUTTON_SELECT_BOOL:
			_button_pressed(BUTTON_SELECT)
	if QWERTY_HOP:
		for i in range(HASKELL_COUNT):
			if Input.is_key_pressed(QWERTY_VEC[i]):
				jump($SpriteList.get_children()[i])
		if Input.is_key_pressed(KEY_SPACE):
			for i in range(100):
				if HOP_COUNT >= PHANTOM_HOP_PRICE and HASKELL_COUNT > PHANTOM_HOP_UPGRADE:
					_phantom_hop()
				if HOP_COUNT >= MAKE_FRIEND_PRICE:
					_make_friend()
	var haskell_hopping_curr = 0
	for s in $SpriteList.get_children():
		if s.jump:
			haskell_hopping_curr += 1
	var hop_string = "Hop"
	if HOP_COUNT != 1:
		hop_string += "s" 
	$HBoxContainer/HopCount.text = "[center]"+str(HOP_COUNT)+" "+hop_string+"[/center]"
	if HOP_COUNT >= PHANTOM_HOP_PRICE or PHANTOM_HOP_UPGRADE > 0:
		$HBoxUpgrade/PhantomHop.show()
		var message
		
		if HASKELL_COUNT > PHANTOM_HOP_UPGRADE:
			if HOP_COUNT >= PHANTOM_HOP_PRICE:
				$HBoxUpgrade/PhantomHop.disabled = false
			else:
				$HBoxUpgrade/PhantomHop.disabled = true
			message = str(PHANTOM_HOP_PRICE) + " Hops"
		else:
			$HBoxUpgrade/PhantomHop.disabled = true
			message = "Not Enough Friends"
		$HBoxUpgrade/PhantomHop.text = "Phantom Hop (" + str(PHANTOM_HOP_UPGRADE) + ")\n" + message

	if HOP_COUNT >= MAKE_FRIEND_PRICE or HASKELL_COUNT > 1:
		$HBoxUpgrade/MakeFriend.show()
		var message = str(MAKE_FRIEND_PRICE) + " Hops"
		
		if HOP_COUNT >= MAKE_FRIEND_PRICE:
			$HBoxUpgrade/MakeFriend.disabled = false
		else:
			$HBoxUpgrade/MakeFriend.disabled = true
		
		$HBoxUpgrade/MakeFriend.text = "Make Friend (" + str(HASKELL_COUNT) + ")\n" + message
	
	if HASKELL_COUNT >= 9:
		if QWERTY_HOP:
			$HBoxUpgrade/QWERTYHop.hide()
			for button in $BoxHop.get_children():
				button.hide()
		else:
			$HBoxUpgrade/MakeFriend.disabled = true
			$HBoxUpgrade/MakeFriend.text = "Make Friend (" + str(HASKELL_COUNT) + ")\nFriend Overflow"
			$HBoxUpgrade/QWERTYHop.show()
			var message = str(QWERTY_HOP_PRICE) + " Hops"
			
			if HOP_COUNT >= QWERTY_HOP_PRICE:
				$HBoxUpgrade/QWERTYHop.disabled = false
			else:
				$HBoxUpgrade/QWERTYHop.disabled = true
			
			$HBoxUpgrade/QWERTYHop.text = "QWERTY Hop\n" + message
	if QWERTY_HOP and HOP_COUNT >= BOSS_BATTLE_PRICE / 2:
		$HBoxUpgrade/BossBattle.show()
		
		var message = str(BOSS_BATTLE_PRICE) + " Hops"
		
		if HOP_COUNT >= BOSS_BATTLE_PRICE:
			$HBoxUpgrade/BossBattle.disabled = false
		else:
			$HBoxUpgrade/BossBattle.disabled = true
		
		$HBoxUpgrade/BossBattle.text = "Boss Battle\n" + message
		
	
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
	if !sprite.jump:
		HOP_COUNT += 1
		sprite.jump = true
		if sprite.phantom:
			sprite.vel_y = -VEL_JUMP_Y * 1.3
		else:
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
	if PHANTOM_HOP_UPGRADE == 0:
		$Tip.text = "If there's something strange, In your neighborhood, Who you gonna call?"
		$Tip.show()
		$Tip/Button.disabled = true
		$Tip/Timer.start()
	if HASKELL_COUNT == 1:
		PHANTOM_HOP_PRICE = 50
	else:
		PHANTOM_HOP_PRICE += 50
	#$HBoxHop.get_children()[AUTO_HOP_COUNT].hide()
	$SpriteList.get_children()[PHANTOM_HOP_UPGRADE].phantom_hop = true
	$SpriteList.get_children()[PHANTOM_HOP_UPGRADE]._on_timer_timeout()
	#JUMP[AUTO_HOP_COUNT] = true
	#jump($HBoxHop.get_children()[AUTO_HOP_COUNT])
	PHANTOM_HOP_UPGRADE += 1

func _make_friend():
	if HASKELL_COUNT == 1:
		$Tip.text = "Maybe the real treasure was the friends we made along the way"
		$Tip.show()
		$Tip/Button.disabled = true
		$Tip/Timer.start()
		
	MAKE_FRIEND_PRICE = floor(MAKE_FRIEND_PRICE * 1.2)
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
	friend_button.connect("button_down",Callable(self,"_button_pressed").bind(friend_button))
	
	friend.button = friend_button	
	
	HASKELL_COUNT += 1

func _qwerty_hop():
	if not QWERTY_HOP:
		$Tip.text = "You have leveled up to keyboard warrior. YEET AWAY YOUR MOUSE (gently).\nUse 1 to 0, Q to P, A to L, Z to M to Hop, Spacebar to Upgrade All"
		$Tip.show()
		$Tip/Button.disabled = true
		$Tip/Timer.start()
	QWERTY_HOP = true
	#while PHANTOM_HOP_UPGRADE < HASKELL_COUNT:
		#_phantom_hop()
		#$HBoxUpgrade/PhantomHop.hide()

func _boss_battle():
	$Tip.text = "A monad is a monoid in a category of endofunctors"
	$Tip.show()
	$Tip/Button.disabled = true
	$Tip/Timer.start()
	BOSS_BATTLE = true
	

func _on_button_button_down() -> void:
	$Tip.hide()
	
	if BOSS_BATTLE:
		get_tree().change_scene_to_file("res://scenes//bossbattle.tscn")


func _on_timer_timeout() -> void:
	$Tip/Button.disabled = false
