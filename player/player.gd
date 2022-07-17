extends KinematicBody2D

export var speed: int = 200
export var dash_speed: int = 2000
var prev_dice_roll: int
var dice_roll: int
var velocity: Vector2
var dash_vector: Vector2
var arrow: bool = true
var immobile:bool = false

func _ready():
	dice_roll = state.roll_dice()
	prev_dice_roll = dice_roll
	self.set_collision_layer(1)
	self.set_collision_mask(7)
	self.add_to_group("player")
	immobile = false
 
func _on_lost_dice(dice_num):
	dice_roll = state.roll_dice()
	prev_dice_roll = dice_roll
	$explosion.emitting = true
	$exp.start()
	

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
var dashing: bool = false;
var dash_timer: float = 0;
func _unhandled_input(event):
	if(event.is_action_pressed("ui_left_click") && dash_ready && not immobile):
		arrow = true
	if(event.is_action_released("ui_left_click") && dash_ready && not immobile):
		dash = true;
		dash_ready = false
		dash_callback.reset_counter()
		dash_vector = - get_node(".").position + get_global_mouse_position()
		arrow = true

const epsilon = 1e-4
func handle_animation():
	
	if(arrow): 
		$Arrow.visible = true
		$Arrow.rotation = (get_node(".").position - get_global_mouse_position()).angle() - PI/2
		$Arrow.position = - Vector2(
			sin((get_node(".").position - get_global_mouse_position()).angle() + PI/2) * 100,
			-cos((get_node(".").position - get_global_mouse_position()).angle() + PI/2) *100
		)
	else:
		$Arrow.visible = false
	
	if immobile:
		$AnimatedSprite.play("dizzy-"+ str(dice_roll))
		yield($AnimatedSprite, "animation_finished")
		immobile = false
		
	else:
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
		self.set_collision_layer(0)
		self.set_collision_mask(3)
		dash = false
		dashing = true
		dash_timer = 0.2
		var dash_dir = dash_vector.normalized()
		velocity = dash_dir * dash_speed
		prev_dice_roll = dice_roll
		dice_roll = state.roll_dice()
		print(dice_roll)
		handle_animation()
		$particles.texture = $AnimatedSprite.get_sprite_frames().get_frame(
			$AnimatedSprite.get_animation(),
			$AnimatedSprite.get_frame()
		)
		$particles.emitting = true;
	elif dash_timer > 0:
		# wiat for timer to disipate
		if get_slide_count() > 0:
			var collision = get_slide_collision(0)
			if collision != null:
				velocity = velocity.bounce(collision.normal)
		dash_timer -= delta
	else:
		$particles.emitting = false;
		if not immobile:	
			dashing = false
			self.set_collision_layer(1)
			self.set_collision_mask(7)
			# normal movement
			velocity = get_movement_input() * speed
		else:
			velocity *= (1-delta)
			
	move_and_slide(velocity)

signal take_damage(dice_num)
signal gave_damage(dice_num)

func _on_collision(body):
	if (body.is_in_group("balls") or body.is_in_group("boss")) and not immobile:
		if(dashing):
			# handle giving dammage from UI
			var body_num = body.health
			body.hurt(self)
			if(body_num == prev_dice_roll):
				emit_signal("gave_damage", prev_dice_roll)
			
			var r:int = state.rng.randi_range(1,3)
			
			if r == 1:
				$"hitA".play()
			elif r == 2:
				$"hitD".play()
			elif r == 3:
				$"hitE".play()
			
		else:
			emit_signal("take_damage", dice_roll)
			# handle taking damage from UI
			
			$"damage".play()
			immobile = true
			var dir = (   self.position - body.position).normalized()
			self.velocity = max(abs(  body.get_linear_velocity().dot(dir) ) , 30) * dir
			dice_roll = state.roll_dice()
 
			if body.is_in_group("balls") and body.is_bullet:
				body.die()
	 
 
func _on_exp_body_entered(body):
	pass # Replace with function body.
