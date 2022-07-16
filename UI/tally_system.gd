extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var hits = [0,0,0,0,0,0]
var damage = [0,0,0,0,0,0]
var super = [0,0,0,0,0,0]

signal game_over
signal attack_bonus(super_boost, dice_num)


func _on_player_gave_damage(dice_num):
	print("hit")
	if hits[dice_num - 1] != 10:
		hits[dice_num - 1] += 1
	
		get_child(dice_num-1).update_gui(hits[dice_num-1], damage[dice_num-1], super[dice_num -1])


func _on_player_take_damage(dice_num):
	print("damage")
	if damage[dice_num -1] != 3:
		damage[dice_num - 1] += 1
	
		get_child(dice_num-1).update_gui(hits[dice_num-1], damage[dice_num-1], super[dice_num -1])
