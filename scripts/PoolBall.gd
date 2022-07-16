extends KinematicBody2D


var weight : float = randi() % 8 + 12
var velocity = Vector2(0,0)

 
func _ready():
	add_to_group("balls")
	self.velocity.x  = 400 * randf()
	self.velocity.y  = 400 * randf()
	

	
func _physics_process(delta):
#	if get_slide_count() > 0:
#		var collision = get_slide_collision(0)
#		if collision != null:
#			velocity = velocity.bounce(collision.normal)
#
#
	var coll_info = move_and_collide(self.velocity * delta)

	if coll_info :
		var alpha = 0.95 # slowing down on ca
		var other = coll_info.collider
		
		var coll_direction = coll_info.normal 
		
		if other.is_in_group("balls") : 
			
			# collision normal using that both objects are circular
			#coll_direction = (other.position - self.position).normalized()
			alpha = other.weight / weight
			other.velocity = other.velocity.bounce( coll_direction) /alpha
			other.move_and_collide(other.velocity * delta)

		self.velocity = alpha * self.velocity.bounce( coll_direction)
		move_and_collide(self.velocity * delta)
