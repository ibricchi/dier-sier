extends KinematicBody2D

export var speed: int = 200
export var dash_speed: int = 2000
export var dice_roll: int = 6
var velocity: Vector2
var dash_vector: Vector2
var rng = RandomNumberGenerator.new()
var arrow:bool = false


func _ready():
	self.add_to_group("player")

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
	if(event.is_action_pressed("ui_left_click")):
		arrow = true
	if(event.is_action_released("ui_left_click") && dash_ready):
		dash = true;
		dash_ready = false
		dash_callback.reset_counter()
		dash_vector = get_node(".").position - get_global_mouse_position()
		arrow = false

const epsilon = 0.0001
func handle_animation():
	
	if(arrow):
		$Arrow.visible = true
		$Arrow.rotation = (get_node(".").position - get_global_mouse_position()).angle()+ PI/2
		$Arrow.position = Vector2(
			sin((get_node(".").position - get_global_mouse_position()).angle() + PI/2) * 100,
			-cos((get_node(".").position - get_global_mouse_position()).angle() + PI/2) *100
		)
	else:
		$Arrow.visible = false
	
	if(velocity.length_squared() < epsilon):
		#idle
		$AnimatedSprite.play("idle-"+ str(dice_roll))
		return
	
	# handle velocities
	if velocity.y > 0: #upwards
		if velocity.y > abs(velocity.x): # upwards is stronger than right legft
			$AnimatedSprite.play("run-f-"+ str(dice_roll))
		elif velocity.x > 0: #right
			$AnimatedSprite.play("run-s-"+ str(dice_roll))
			$AnimatedSprite.flip_h = false
		else: # left
			$AnimatedSprite.play("run-s-"+ str(dice_roll))
			$AnimatedSprite.flip_h = true
	else: #downwards
		if -velocity.y > abs(velocity.x): # downwards is stronger than right legft
			$AnimatedSprite.play("run-b-"+ str(dice_roll))
		elif velocity.x > 0: #right
			$AnimatedSprite.play("run-s-"+ str(dice_roll))
			$AnimatedSprite.flip_h = false
		else: # left
			$AnimatedSprite.play("run-s-"+ str(dice_roll))
			$AnimatedSprite.flip_h = true

func _process(delta):
	handle_animation()

func _physics_process(delta):
	if dash:
		dash = false
		dash_timer = 0.2
		var dash_dir = dash_vector.normalized()
		velocity = dash_dir * dash_speed
		rng.randomize()
		dice_roll = rng.randi_range(1, 6)
		print(dice_roll)
		handle_animation()
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
	
