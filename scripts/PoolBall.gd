extends RigidBody2D


var velocity : Vector2 = Vector2(0,0)

 
func _ready():
	add_to_group("balls")
	mass = randi() % 4 + 12
	self.set_gravity_scale(0.0)
	self.linear_damp = 0.05
	
	self.contact_monitor = true
	self.contacts_reported = 1
	
	#self.apply_central_impulse( Vector2( 750 * randf()  , 750 * randf()  ) )
	self.set_bounce(1.0)
	 

	
func _physics_process(delta):
	if $Stopped_Timer.is_stopped():
		if self.linear_velocity.length_squared() < 3000:
			self.linear_damp = 0.1
		if self.linear_velocity.length_squared() < 1000:
			self.linear_damp = 0.3
		if self.linear_velocity.length_squared() < 400 : 
			self.linear_damp = 0.8
			
			$Stopped_Timer.wait_time = randf() * 3 + 0.5
			$Stopped_Timer.start()
			$Tween.interpolate_property(self,"modulate",self.modulate,Color.red,$Stopped_Timer.time_left,Tween.TRANS_LINEAR)
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
	self.linear_damp = 0.05
	
	var angle = randf() * 2 * PI
	var strength = 2 * randf() + 2
	self.apply_central_impulse( 2e3* strength * Vector2( cos(angle)  , sin(angle)) )
	$Tween.stop(self)
	self.modulate = Color(1,1,1)
	
