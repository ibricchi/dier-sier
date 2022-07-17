extends Control

signal game_over
signal attack_bonus(super_boost, dice_num)

func _on_player_gave_damage(dice_num):
	if state.hits[dice_num - 1] != 6:
		state.hits[dice_num - 1] += 1
	state.super[dice_num-1] = state.hits[dice_num-1] / 3
	get_child(dice_num-1).update_gui(state.hits[dice_num-1], state.damage[dice_num-1], state.super[dice_num -1])
	var super = state.super[dice_num - 1]
	if super == 0:
		$dice_frame.texture = load("res://assets/dice_normal.png")
	elif super == 1:
		$dice_frame.texture = load("res://assets/dice_super1.png")
	elif super == 2:
		$dice_frame.texture = load("res://assets/dice_super2.png")

func _ready():
	state.connect("dice_rolled", self, "_on_dice_roll")

func _on_dice_roll(dice_num):
	var super = state.super[dice_num - 1]
	if super == 0:
		$dice_frame.texture = load("res://assets/dice_normal.png")
	elif super == 1:
		$dice_frame.texture = load("res://assets/dice_super1.png")
	elif super == 2:
		$dice_frame.texture = load("res://assets/dice_super2.png")
	$dice_frame/dice_num.texture = load("res://assets/dice_" + str(dice_num) + ".png")

func check_exit():	
	var legal = []
	for i in 6:
		if state.damage[i] < 3:
			legal.push_back(i + 1)
	if len(legal) == 0:
		state.stop_timer()
		emit_signal("game_over")
		

signal lost_dice(dice_num)
func _on_player_take_damage(dice_num):
	if state.damage[dice_num -1] != 3:
		state.damage[dice_num - 1] += 1
		get_child(dice_num-1).update_gui(state.hits[dice_num-1], state.damage[dice_num-1], state.super[dice_num -1])
		if state.damage[dice_num-1] == 3:
			check_exit()
			emit_signal("lost_dice", dice_num)
