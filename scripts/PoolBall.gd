extends RigidBody2D

var health: int =  1;
var velocity : Vector2 = Vector2(0,0)
export var max_shot_strength = 1e3
 
func _ready():
	add_to_group("balls")
 
	self.mass = randi() % 8 + 12
 
	set_collision_layer(4)
	set_collision_mask(7)
	
	update_color()
	self.set_gravity_scale(0.0)
	self.linear_damp = 0.3
	
	self.contact_monitor = true
	self.contacts_reported = 1
	
	self.set_bounce(1.0)
	self.update_color()
	
func set_health(hp):
	self.health = hp
	self.update_color()

func die():
	# handle death animation here
	$number.hide()
	$Poolball.hide()
	$Death_particles.emitting = true
	
	self.set_collision_layer(0)
	self.set_collision_mask(0)
	self.remove_from_group("balls")
	
	yield(get_tree().create_timer(6), "timeout")
	
	get_parent().remove_child(self)
	
	queue_free()

func hurt():
	# handle hurt animation here
	for player in get_tree().get_nodes_in_group("player"):
		$Hurt_particles.amount = 20 + 5 * self.health
		$Hurt_particles.direction = player.velocity.normalized()
		$Hurt_particles.color = $Poolball.modulate
		$Hurt_particles.emitting = true
	health -= state.current_attack_power
	if(health <= 0):
		die()
	else:
		update_color()
		
	$Stopped_Timer.stop()

func update_color():
	var ball_res = load("res://assets/ball%s.png" % [self.health])
	 
	$number.texture = ball_res
	$number.modulate = Color(1,1,1)
	if(health == 1):
		$Poolball.modulate = Color.yellow
	elif(health == 2):
		$Poolball.modulate = Color.blue
	elif(health == 3):
		$Poolball.modulate = Color.red
	elif(health == 4):
		$Poolball.modulate = Color.orangered
	elif(health == 5):
		$Poolball.modulate = Color.green
	elif(health == 6):
		$Poolball.modulate = Color.brown
	elif(health == 7):
		$Poolball.modulate = Color.maroon
	elif(health == 8):
		$Poolball.modulate = Color.black

func _physics_process(delta):
	 
	if $Stopped_Timer.is_stopped():
		if self.linear_velocity.length_squared() < 3000:
			self.linear_damp = 0.5
		if self.linear_velocity.length_squared() < 1200:
			self.linear_damp = 1
		if self.linear_velocity.length_squared() < 800 : 
			self.linear_damp = 1.5
			
			$Stopped_Timer.wait_time = randf()  + 1.5
			$Stopped_Timer.start()
			$Tween.interpolate_property($number,"modulate",self.modulate,Color.red,$Stopped_Timer.time_left,Tween.TRANS_CUBIC, Tween.EASE_IN)
			$Tween.start()
	
func _on_PoolBall_body_entered(body):
	self.linear_velocity *= 0.95 # slow down a bit when colliding
	
	# code to stop "charging up" when hit 
	#if not $Stopped_Timer.is_stopped():
	#	self.linear_damp = 0.01
	#	$Tween.stop(self)
	#	self.modulate = Color(1,1,1)
	#	$Stopped_Timer.stop()


func _on_Stopped_Timer_timeout():
	self.linear_damp = 0.3
	
	if self.health:
		for player in get_tree().get_nodes_in_group("player"):
			var dir = (player.position - self.position).normalized()
			var angle = ((randf() * 0.5 - 0.25) * PI) / self.health
			var strength =  randf() + 4 + self.health
			var shot_dir = 0.3 * Vector2( cos(angle)  , sin(angle)) + 0.7*dir
			self.apply_central_impulse( max_shot_strength*  strength * shot_dir )
	
	$Tween.stop($number)
	update_color()
	
