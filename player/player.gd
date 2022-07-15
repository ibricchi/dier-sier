extends KinematicBody2D

export var speed: int = 200
export var dash_speed: int = 2000
var velocity: Vector2

func get_movement_input():
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity.normalized()

var dash_ready: bool = false;
var dash_callback
func _on_dash_bar_ready_to_use(dc):
	dash_callback = dc;
	dash_ready = true;

var dash: bool = false;
var dash_timer: float = 0;
func _unhandled_input(event):
	if(event.is_action_pressed("ui_left_click") && dash_ready):
		dash = true;
		dash_ready = false
		dash_callback.reset_counter()

func _physics_process(delta):
	if dash:
		dash = false
		dash_timer = 0.2
		var dash_dir = get_local_mouse_position().normalized()
		velocity = dash_dir * dash_speed
	elif dash_timer > 0:
		# wiat for timer to disipate
		if get_slide_count() > 0:
			var collision = get_slide_collision(0)
			if collision != null:
				velocity = velocity.bounce(collision.normal)
		dash_timer -= delta
	else:
		# normal movement
		velocity = get_movement_input() * speed

	move_and_slide(velocity)
	
