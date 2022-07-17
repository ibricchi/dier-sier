extends Node

var hits: Array = [0,0,0,0,0,0]
var damage: Array = [0,0,0,0,0,0]
var super: Array = [0,0,0,0,0,0]

signal reload_overlay

onready var rng = RandomNumberGenerator.new()

func roll_dice():
	var legal = []
	for i in 6:
		if damage[i] < 3:
			legal.push_back(i + 1)
	if len(legal) == 0:
		return 0
	return legal[rng.randi() % len(legal)]
