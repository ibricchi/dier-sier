extends Node2D

signal ready_to_use(callback, obj)

onready var load_bar: Sprite = get_node("load")
var load_bar_y: float

func _ready():
	load_bar_y = load_bar.scale.y
	timer = recharge_time
	#print(load_bar_y)

export var recharge_time: float = 1
var ended: bool = false
var timer: float 

func reset_counter():
	ended = false
	timer = recharge_time

func _process(delta):
	if(timer > 0):
		timer -= delta
	elif not ended:
		ended = true
		emit_signal("ready_to_use", self)
	load_bar.scale.y = (recharge_time - timer)/recharge_time*load_bar_y;
	#print(load_bar.scale.y)
	
