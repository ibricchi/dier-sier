extends RigidBody2D


var velocity : Vector2 = Vector2(0,0)
export var max_shot_strength = 1e3
 
func _ready():
	add_to_group("balls")
	self.mass = randi() % 8 + 12
	self.set_gravity_scale(0.0)
	self.linear_damp = 0.2
	
	self.contact_monitor = true
	self.contacts_reported = 1
	
	self.set_bounce(1.0)
	 

	
func _physics_process(delta):
	if $Stopped_Timer.is_stopped():
		if self.linear_velocity.length_squared() < 3000:
			self.linear_damp = 0.5
		if self.linear_velocity.length_squared() < 1000:
			self.linear_damp = 1
		if self.linear_velocity.length_squared() < 400 : 
			self.linear_damp = 1.5
			
			$Stopped_Timer.wait_time = randf()  + 1.5
			$Stopped_Timer.start()
			$Tween.interpolate_property(self,"modulate",self.modulate,Color.red,$Stopped_Timer.time_left,Tween.TRANS_CUBIC, Tween.EASE_IN)
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
	self.linear_damp = 0.5
	
	for player in get_tree().get_nodes_in_group("player"):
		var dir = (player.position - self.position).normalized()
		var angle = (randf() * 0.5 - 0.25) * PI
		var strength =  randf() + 4
		var shot_dir = 0.3 * Vector2( cos(angle)  , sin(angle)) + 0.7*dir
		self.apply_central_impulse( max_shot_strength*  strength * shot_dir )
	
	$Tween.stop(self)
	self.modulate = Color(1,1,1)
	
