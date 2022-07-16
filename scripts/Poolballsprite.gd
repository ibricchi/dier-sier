extends KinematicBody2D

var animations = 0
var velocity = Vector2.ZERO
var max_size = Vector2(1.6,1.6)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  

func _process(delta):
	move_and_collide(velocity * delta)

func start_spawn_anim():
	scale = Vector2(0,0)
	$Tween.interpolate_property(self, "scale", Vector2.ZERO, max_size , 0.6, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
 

func _on_Tween_tween_completed(object, key):
	self.animations += 1
	if self.animations > 1 : 
		$"/root/main".spawn_rigid_poolball(self.position, self.velocity)
		get_parent().remove_child(self)
		queue_free()
	else : 
		$Tween.interpolate_property(self, "scale", max_size, Vector2.ONE,  0.3, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	
	
