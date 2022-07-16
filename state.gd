extends Node


var current_attack_power: int = 1
var points: Array = [0,0,0,0,0,0]

var damage: Array = [0,0,0,0,0,0]

signal reload_overlay

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if(randf() > 0.5):
			points[randi() % 6] += 1
		else:
			damage[randi() % 6] += 1
		print("points: ", points)
		print("damage: ", damage)
		emit_signal("reload_overlay")
