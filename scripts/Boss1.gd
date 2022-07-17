extends RigidBody2D

var health : int = 100
var is_aggressive = true
var time_since_last_attack = 0.0
var max_shot_strength = 2e4

onready var player = self.get_tree().get_root().get_node("main/player")

func _ready():
	self.mass = 15
	add_to_group("boss")
	$Poolball.modulate = Color.maroon
	$number.modulate = Color(1,1,1)
	set_collision_layer(4)
	set_collision_mask(7)
	self.set_gravity_scale(0.0)
	self.linear_damp = 0.2
	self.angular_damp = 0.1
	self.contact_monitor = true
	self.contacts_reported = 1
	self.set_bounce(1.0)
	
	$Stopped_Timer.start()
	number_go_red()
	
func _physics_process(delta):
	time_since_last_attack += delta 
	if is_aggressive: 
		if time_since_last_attack > 2.0 : 
			time_since_last_attack -= randf() + 1.0
			
			var dir = (player.position - self.position).normalized()
			var angle = ((randf() * 0.3 - 0.15) * PI) 
			 
			var shot_dir = 0.1 * Vector2( cos(angle)  , sin(angle)) + 0.9*dir
			self.apply_central_impulse( randf() * max_shot_strength * shot_dir )
			
		if not $Tween.is_active():
			number_go_red()
func die():
	# handle death animation here
	$number.hide()
	$Poolball.hide()
	$Death_particles.emitting = true
	
	self.set_collision_layer(0)
	self.set_collision_mask(0)
	self.remove_from_group("boss")
	
	yield(get_tree().create_timer(6), "timeout")
	
	get_parent().remove_child(self)
	
	queue_free()
	
		
func hurt():
	health -= 5	
	if(health <= 0):
		die()
			
func number_go_red():
	$Tween.interpolate_property($number,"modulate",Color(1,1,1),Color.red, 1.2 ,Tween.TRANS_BOUNCE , Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Stopped_Timer_timeout():
	self.is_aggressive = false
	$Tween.stop($number)
	$number.modulate = Color(1,1,1)
	
	self.linear_damp = 5
	self.angular_damp = 8
	$Tween.interpolate_property($number,"modulate",Color(1,1,1),Color.green, 5,Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(randf() * 4 + 2), "timeout")
	number_go_red()
	yield(get_tree().create_timer(1.5), "timeout")
	self.is_aggressive = true
	self.linear_damp = 0.2
	self.angular_damp = 0.1
	$Stopped_Timer.start()
	
