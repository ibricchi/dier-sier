extends Node

var hits: Array = [0,0,0,0,0,0]
var damage: Array = [0,0,0,0,0,0]
var super: Array = [0,0,0,0,0,0]
var points: int = 0
var wave: int = 6
var time: float = 0

var volume: float = -5
var sfx_volume: float = -5

var win: bool = false

func add_points(amm):
	points += amm

signal reload_overlay
signal dice_rolled(num_rolled)

onready var rng = RandomNumberGenerator.new()
onready var game_scene: PackedScene = load("res://main.tscn")
func roll_dice():
	rng.randomize()
	var legal = []
	for i in 6:
		if damage[i] < 3:
			legal.push_back(i + 1)
	if len(legal) == 0:
		return 0
	var ret = legal[rng.randi() % len(legal)]
	emit_signal("dice_rolled", ret)
	return ret

func _process(delta):
	if (timer_running):
		time += delta

var timer_running: bool = false
func start_timer(reset: bool):
	if (reset):
		time = 0
	timer_running = true

func stop_timer():
	timer_running = false
