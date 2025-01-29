extends Control


# Called when the node enters the scene tree for the first time.
var COUNT = 0
var GRAVITY = 0.5 # top_y = 0, bot_y > 0
var SPRITE_INIT_X
var SPRITE_INIT_Y

var DIR = -1
var CURR_POS
var VEL_Y
var VEL_X
var VEL_JUMP_Y = 9
var VEL_JUMP_X = 9
var JUMP = false
var RESIZE_WINDOW = false


func _ready() -> void:
	print("LES GO")
	reset_var()
	
	$Sprite.position.x = SPRITE_INIT_X
	$Sprite.position.y = SPRITE_INIT_Y
	$Button.pressed.connect(self._button_pressed)
	get_viewport().connect("size_changed", reset_var)

func reset_var():
	$Button.disabled = false
	JUMP = false
	SPRITE_INIT_X = get_viewport_rect().size.x / 2
	SPRITE_INIT_Y = get_viewport_rect().size.y / 4
	$Sprite.position.x = SPRITE_INIT_X
	$Sprite.position.y = SPRITE_INIT_Y
	VEL_X = 0
	VEL_Y = 0
	CURR_POS = 1
	if $Sprite/Sprite.flip_h:
		DIR = 1
	else:
		DIR = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HopCount.text = "[center]"+str(COUNT)+"[/center]"
	if $Sprite.position.y < SPRITE_INIT_Y:
		VEL_Y += GRAVITY
	$Sprite.position.y += VEL_Y
	$Sprite.position.x += VEL_X
	
	if JUMP and $Sprite.position.y > SPRITE_INIT_Y:
		$Button.disabled = false
		JUMP = false
		$Sprite.position.y = SPRITE_INIT_Y
		VEL_X = 0
		VEL_Y = 0
		CURR_POS += DIR

		if CURR_POS == 0 or CURR_POS == 2:
			DIR = -DIR
	
func _button_pressed():
	if not JUMP:
		COUNT += 1
		JUMP = true
		VEL_Y = -VEL_JUMP_Y
		VEL_X = DIR * VEL_JUMP_X
		$Button.disabled = true
		if CURR_POS == 0 or CURR_POS == 2:
			$Sprite/Sprite.flip_h = !$Sprite/Sprite.flip_h
