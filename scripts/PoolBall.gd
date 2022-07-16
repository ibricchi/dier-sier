extends RigidBody2D


var velocity : Vector2 = Vector2(0,0)

 
func _ready():
	add_to_group("balls")
	mass = randi() % 4 + 12
	self.set_gravity_scale(0.0)
	#self.velocity.x  = 300 * randf()
	#self.velocity.y  = 200 * randf()
	self.apply_central_impulse( Vector2( 750 * randf()  , 750 * randf()  ) )
	self.set_bounce(1.0)

	
#func _physics_process(delta):
##	if get_slide_count() > 0:
##		var collision = get_slide_collision(0)
##		if collision != null:
##			velocity = velocity.bounce(collision.normal)
##
##
#	var coll_info = move_and_collide(self.velocity * delta)
#
#	if coll_info :
#		var alpha = 0.95 # slowing down on ca
#		var other = coll_info.collider
#		# if hits the wall use normal collision
#		var coll_direction = coll_info.normal 
#
#		if other.is_in_group("balls") : 
#
#			# collision normal using that both objects are circular
#			coll_direction = (other.position - self.position).normalized()
#			alpha = other.weight / self.weight
#
#			# velocity decomposition for self
#			var self_along_collision = coll_direction.dot(self.velocity) * coll_direction
#			var self_off_collision = self.velocity - self_along_collision
#			print(alpha)
#
#			# velocity decomposition for other
#			var other_along_collision = coll_direction.dot(other.velocity) * coll_direction
#			var other_off_collision = other.velocity - other_along_collision 
#
#			#other.velocity = self_along_collision   + other_off_collision
#			self.velocity = self_off_collision + other_off_collision 
#
#
#			move_and_collide(self.velocity*delta)
#			#other.move_and_collide(other.velocity)
#
#		else:
#			self.velocity = alpha * self.velocity.bounce( coll_direction)
#		#move_and_collide(self.velocity * delta)
