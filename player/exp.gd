extends Area2D

export var max_time: float = 1
export var max_scale: float = 126*2
var remaining_time: float;

func start():
	remaining_time = max_time;

func _physics_process(delta):
	if(remaining_time > 0):
		$cs.shape.radius = max_scale * (max_time - remaining_time) / max_time
#		$cs.shape.radius = 126
		remaining_time -= delta
	else:
		$cs.shape.radius = 0

func _on_collision(body):
	print("Collision")
	if body.is_in_group("balls"):
		#print("Body Valid")
		#print(remaining_time)
		if remaining_time > 0:
			print("Time Valid")
			body.die()
	if body.is_in_group("boss"):
		body.health -= 10 
		body.hurt()
