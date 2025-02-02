extends ColorRect

var SHOOT = 0
var DEAD = 0
var TOTAL = 8
var SHOOT_BOOL = false
var FUNC_VEC = []
var MULT_VEC = []
var FUNC_MAP = [add_1, mult_2]
var TOTAL_DAMAGE = 1
var WIN = false
var GAME_START = false
var LIVES = 6

var MAIN
# MAIN.get_node("

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAIN = get_tree().get_root().get_node("BossBattle")
	#print($MultSync.global_position)
	get_parent().get_node("Note").hide()
	get_parent().get_node("Win").hide()
	MAIN.get_node("VBoxContainer/Attack").hide()
	hide()
	randomize()
	for i in range(TOTAL / 2):
		FUNC_VEC.append(0)
	for i in range(TOTAL / 2):
		FUNC_VEC.append(1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MAIN.get_node("ProgressBar").value == 0 and not WIN:
		#print("in here")
		WIN = true
		MAIN.get_node("Win/Timer").start()
	if DEAD == TOTAL:
		SHOOT = 0
		SHOOT_BOOL = false
		DEAD = 0
		MULT_VEC = []
		self.hide()
		$Timer.stop()
		MAIN.get_node("Player").HOP_POWER = 0
		MAIN.get_node("VBoxContainer/ProgressBar").show()
		MAIN.get_node("VBoxContainer/Attack/Timer").start()
		var curr_health = clampf(MAIN.get_node("ProgressBar").value - TOTAL_DAMAGE, 0, 100)
		MAIN.get_node("ProgressBar").value = curr_health 
		for c in MAIN.get_children():
			if c is Sprite2D and c.get_node_or_null("Area2D") != null and c.get_node("Area2D").collision_layer == 0b11000000:
				c.VEL_X = c.VEL_STORE_X
				c.VEL_Y = c.VEL_STORE_Y
		

	if Input.is_key_pressed(KEY_SPACE) and MAIN.get_node("Player").HOP_POWER >= 100:
		for c in MAIN.get_children():
			if c is Sprite2D and c.get_node_or_null("Area2D") != null and c.get_node("Area2D").collision_layer == 0b11000000:
				c.VEL_X = 0
				c.VEL_Y = 0
		MAIN.get_node("Player").HOP_POWER = 0
		MAIN.get_node("VBoxContainer/ProgressBar").hide()
		MAIN.get_node("VBoxContainer/Attack").show()
		SHOOT = 0
		SHOOT_BOOL= true
		FUNC_VEC.shuffle()
		self.show()
		SPAWN_NOTE()
		$Timer.start()
	var min_dist = 99999999999
	var min_sprite
	var score
	if Input.is_action_just_pressed("left"):
		print("left")
		for child in self.get_children():
			if child.get_node_or_null("Area2D") != null and child.get_node("Area2D").collision_layer == 0b00000110 and child.add and child.DEAD == false:
				var dist = (child.global_position - $AddSync.get_size() / 2).distance_to($AddSync.global_position)
				if dist < min_dist:
					min_dist = dist
					min_sprite = child
		print("girl ", min_sprite)
				#print(child.global_position - $AddSync.get_size() / 2, $AddSync.global_position)
		#print(min_dist)
		
	if Input.is_action_just_pressed("right"):
		for child in self.get_children():
			if child.get_node_or_null("Area2D") != null and child.get_node("Area2D").collision_layer == 0b00000110 and child.mult and child.DEAD == false:
				var dist = (child.global_position - $MultSync.get_size() / 2).distance_to($MultSync.global_position)
				if dist < min_dist:
					min_dist = dist
					min_sprite = child
		print("boy ", min_sprite)
			
				#print(child.global_position - $AddSync.get_size() / 2, $MultSync.global_position)
	if min_sprite:
		score = 1 - clampf(min_dist, 0, 100) / 100
		MULT_VEC.append(score)
		min_sprite.hide()
		min_sprite.DEAD = true
		update_damage()
		DEAD += 1
		
		#print("what are we hiding? ", min_sprite, " ", score, " ", FUNC_MAP[FUNC_VEC[SHOOT]])

func add_1(x,mult):
	return x + 1 * mult

func mult_2(x, mult):
	return x * 2 * mult

func SPAWN_NOTE():
	var note = get_parent().get_node("Note").duplicate()
	
	self.add_child(note)
	if FUNC_VEC[SHOOT] == 0:
		
		note.global_position.x = $AddSync.global_position.x + $AddSync.get_size().x / 2
		note.global_position.y = $AddPos.global_position.y
		note.add = true
	
	if FUNC_VEC[SHOOT] == 1:
		
		note.global_position.x = $MultSync.global_position.x + $AddSync.get_size().x / 2
		note.global_position.y = $MultPos.global_position.y
		note.mult = true
	note.show()
	SHOOT += 1

func _on_timer_timeout() -> void:
	#print("in the timer ", SHOOT,  " " , TOTAL)
	if SHOOT >= TOTAL:
		#print("STOP?")
		$Timer.stop()
		
		#self.hide()
	else:
		SPAWN_NOTE()
	
func update_damage():
	var FUNC_VEC_STRING = []
	var ind = 0
	var tot = 1
	print("dead ", DEAD, " ", MULT_VEC)
	for f in FUNC_VEC.slice(0,DEAD+1):
		if FUNC_MAP[f] == add_1:
			tot = add_1(tot, MULT_VEC[ind])
			FUNC_VEC_STRING.insert(0, "(+ %.2f)" % [add_1(0, 1) * MULT_VEC[ind]])
		elif FUNC_MAP[f] == mult_2:
			tot = mult_2(tot, MULT_VEC[ind])
			FUNC_VEC_STRING.insert(0, "(* %.2f)" % [mult_2(1, 1) * MULT_VEC[ind]])
		ind += 1
	#"
	#"
	MAIN.get_node("VBoxContainer/Attack").text = "[center](%s) 1 =\n%.2f[/center]" % [" . ".join(FUNC_VEC_STRING),tot]
	TOTAL_DAMAGE = tot
	
	
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().hide()
	#DEAD += 1
	
	if not area.get_parent().DEAD:
		MULT_VEC.append(0)
		update_damage()
		DEAD += 1
	#else:
		#
		#update_damage()
		
		


func _on_button_button_down() -> void:
	GAME_START = true
	MAIN.get_node("Tip").hide()
	MAIN.get_node("AudioStreamPlayer").play()


func _on_sound_button_down() -> void:
	MAIN.get_node("Tip/Button").disabled = false
	MAIN.get_node("Tip/Sound/AudioStreamPlayer").play()


func _on_timerattack_timeout() -> void:
	MAIN.get_node("VBoxContainer/Attack").hide()
	MAIN.get_node("VBoxContainer/Attack/Timer").stop()
	MAIN.get_node("VBoxContainer/Attack/").text = "[center]1 =\n1[/center]"


func _on_playagain_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes//bossbattle.tscn")


func _on_wintimer_timeout() -> void:
	MAIN.get_node("Win").show()


func _on_null_area_entered(area: Area2D) -> void:
	if LIVES > 0 and area.collision_layer == 0b11000000:
		area.get_parent().queue_free()
		LIVES -= 1
		if LIVES >= 1:
			MAIN.get_node("Platform/" + str(LIVES)).queue_free()
		
		if LIVES == 0:
			WIN = true
			MAIN.get_node("Win").show()
			MAIN.get_node("Win").text = "You Lose!"
