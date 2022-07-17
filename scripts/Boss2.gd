 extends RigidBody2D

export var health : int = 100
var is_aggressive = true
var time_since_last_bump = 0.0
var max_shot_strength = 2e4

onready var player = self.get_tree().get_root().get_node("main/player")
onready var poolball_res  : Resource = preload("res://scenes/PoolBall.tscn") 
signal boss_hurt

func _ready():
	
	self.mass = 15
	add_to_group("boss")
	$Poolball.modulate = Color.black
	$number.modulate = Color(1,1,1)
	set_collision_layer(4)
	set_collision_mask(7)
	self.set_gravity_scale(0.0)
	self.linear_damp = 1
	self.angular_damp = 0.5
	self.contact_monitor = true
	self.contacts_reported = 1
	self.set_bounce(1.0)
	 
	
	self.get_tree().get_root().get_node("main").update_health_bar(health)
	
	
	$Firing_Timer.wait_time = randi() % 3 + 1
	$Firing_Timer.start()
	
	
func _physics_process(delta):
	if state.damage != [3,3,3,3,3,3]:
		time_since_last_bump += delta
		
		if time_since_last_bump > 1.5 : 
			time_since_last_bump -= 1.0 + 0.5 * randf()
			
			var dir = ( self.position - player.position).normalized()
			var angle = ((randf() * 1.2 - 0.6) * PI) + sign(dir.y) *  acos(dir.x)
			 
			var shot_dir = 0.7 * Vector2( cos(angle)  , sin(angle)) + 0.3*dir
			self.apply_central_impulse( (0.5 + 0.5 * randf()) * max_shot_strength * shot_dir )
		
		if player: 
			if self and (self.position - player.position).length() > 2000 : 
				self.die()
			
		
func die():
	# handle death animation here
	$number.hide()
	$Poolball.hide()
	state.win = true
	
	var player = get_tree().get_root().get_node("main/player")
	$Death_particles.direction = Vector2.RIGHT.rotated(player.velocity.angle() - rotation)
	$Death_particles.emitting = true
	
	self.set_collision_layer(0)
	self.set_collision_mask(0)
	self.remove_from_group("boss")
	
	yield(get_tree().create_timer(6), "timeout")
	
	get_parent().remove_child(self)
	
	queue_free()
	
	
	
		
func hurt(obj):
	health -= 4	
	$Hurt_particles.amount = 20 + 5 * self.health
	$Hurt_particles.direction = Vector2.RIGHT.rotated(player.velocity.angle() - rotation);
	$Hurt_particles.color = $Poolball.modulate
 
	
	var particle = $Hurt_particles.duplicate()
	self.add_child(particle)
	particle.emitting = true
	
	self.get_tree().get_root().get_node("main").update_health_bar(health)
	
	emit_signal("boss_hurt")
	
	if(health <= 0):
		die()
			
func number_go_red(time):
	$Tween.interpolate_property($number,"modulate",Color(1,1,1),Color.red, time ,Tween.TRANS_QUINT , Tween.EASE_IN)
	$Tween.start()
 
	
var regular_fire = 0

func _on_Firing_Timer_timeout():
	$number.modulate = Color(1,1,1)
	
		
	var to_player = (  player.position- self.position )
	var dir = to_player.normalized()
	
	regular_fire += 1
	var bullet_array = []
	if regular_fire == 5:
		regular_fire -= 5
		
		for i in range(3):
			var bullet = poolball_res.instance()
			
			self.get_tree().get_root().get_node("main").add_child(bullet)
			
			bullet.set_health(randi() % 6 + 1)
			bullet.is_bullet = true
			bullet.get_node("Bullet_Particles").emitting = true
			
			# scale size
			var scaling = 0.6  
			bullet.get_node("Poolball").scale *= scaling
			bullet.get_node("CollisionShape2D").scale *= scaling
			bullet.get_node("number").scale *= scaling
			
			var angle = (0.05* PI) + sign(dir.y) *  acos(dir.x)
			
			
			 
			var shot_dir = 0.7 * Vector2( cos(angle)  , sin(angle)) + 0.3*dir
			
			bullet.linear_damp = 0.01
			bullet.set_linear_velocity( 300 * dir)
			bullet.position = self.position + 60 * shot_dir
			bullet_array.append(bullet)
		
	else:
		
		var bullet = poolball_res.instance()
		
		self.get_tree().get_root().get_node("main").add_child(bullet)
		
		bullet.set_health(randi() % 6 + 1)
		bullet.is_bullet = true
		bullet.get_node("Bullet_Particles").emitting = true
		
		# scale size
		var scaling = 0.70 + randf() * 0.2
		bullet.get_node("Poolball").scale *= scaling
		bullet.get_node("CollisionShape2D").scale *= scaling
		bullet.get_node("number").scale *= scaling
		
		bullet.linear_damp = 0.01
		bullet.set_linear_velocity( 300 * dir)
		bullet.position = self.position + 50 * dir
		bullet_array.append(bullet)
	
	$Firing_Timer.wait_time = randi() % 3 + 1
	number_go_red($Firing_Timer.wait_time)
	$Firing_Timer.start()
	yield(get_tree().create_timer(to_player.length() / 200) , "timeout")
	for bullet in bullet_array:
		bullet.die()
