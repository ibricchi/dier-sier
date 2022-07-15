extends Node2D

signal ready_to_use(callback, obj)

#onready var load_bar: Sprite = get_node("load")

export var recharge_time: float = 5
var ended: bool = false
var timer: float = 0

func reset_counter():
	ended = false
	timer = recharge_time

func _process(delta):
	if(timer > 0):
		timer -= delta
	elif not ended:
		emit_signal("ready_to_use", self)

#func _draw():
#	transform.y = timer / recharge_time
