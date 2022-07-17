 extends RigidBody2D

export var health : int = 100
var is_aggressive = true
var time_since_last_bump = 0.0
var max_shot_strength = 1e3

onready var player = self.get_tree().get_root().get_node("main/player")
signal boss_hurt

func _ready():
	
	self.mass = 15
	add_to_group("boss")
	$Poolball.modulate = Color.black
	$number.modulate = Color(1,1,1)
	set_collision_layer(4)
	set_collision_mask(7)
	self.set_gravity_scale(0.0)
	self.linear_damp = 2
	self.angular_damp = 1
	self.contact_monitor = true
	self.contacts_reported = 1
	self.set_bounce(1.0)
	 
	
	self.get_tree().get_root().get_node("main").update_health_bar(health)
	
	
func _physics_process(delta):
	
	time_since_last_bump += delta
	
	if time_since_last_bump > 0.5 : 
		time_since_last_bump -= 0.5
		
		var dir = ( self.position - player.position).normalized()
		var angle = ((randf() * 0.9 - 0.45) * PI) 
		 
		var shot_dir = 0.1 * Vector2( cos(angle)  , sin(angle)) + 0.9*dir
		self.apply_central_impulse( randf() * max_shot_strength * shot_dir )
	
	if player and (self.position - player.position).length() > 2000 : 
		self.die()
		
		
func die():
	# handle death animation here
	$number.hide()
	$Poolball.hide()
	
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
	health -= 5	
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
	$Tween.interpolate_property($number,"modulate",Color(1,1,1),Color.red, time ,Tween.TRANS_QUINT , Tween.EASE_OUT)
	$Tween.start()
 
	


func _on_Firing_Timer_timeout():
	pass # Replace with function body.
