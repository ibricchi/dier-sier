extends Control

signal game_over
signal attack_bonus(super_boost, dice_num)

func _on_player_gave_damage(dice_num):
	if state.hits[dice_num - 1] != 10:
		state.hits[dice_num - 1] += 1
		get_child(dice_num-1).update_gui(state.hits[dice_num-1], state.damage[dice_num-1], state.super[dice_num -1])



func _unhandled_input(event):
	if(event.is_action_pressed("ui_accept")):
		state.damage = [3,3,3,3,3,3]
		check_exit()

func check_exit():
	var legal = []
	for i in 6:
		if state.damage[i] < 3:
			legal.push_back(i + 1)
	if len(legal) == 0:
		emit_signal("game_over")
		

signal lost_dice(dice_num)
func _on_player_take_damage(dice_num):
	if state.damage[dice_num -1] != 3:
		state.damage[dice_num - 1] += 1
		get_child(dice_num-1).update_gui(state.hits[dice_num-1], state.damage[dice_num-1], state.super[dice_num -1])
		if state.damage[dice_num-1] == 3:
			check_exit()
			emit_signal("lost_dice", dice_num)
