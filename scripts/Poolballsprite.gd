extends KinematicBody2D

var health: int;
var animations = 0
var velocity = Vector2.ZERO
var max_size = Vector2(1.6,1.6)
var is_boss1 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("balls")
	
func set_health(hp):
	if hp == 7:
		self.is_boss1 = true
	self.health = hp
	self.update_color()

func _process(delta):
	move_and_collide(velocity * delta)

func start_spawn_anim():
	scale = Vector2(0,0)
	var speed = velocity.length()
	$Tween.interpolate_property(self, "scale", Vector2.ZERO, (1 + int(is_boss1)) * max_size , 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
 
func update_color():
	var ball_res = load("res://assets/ball%s.png" % [self.health])
	 
	$number.texture = ball_res
	$number.modulate = Color(1,1,1)
	if(health == 1):
		$Poolballsprite.modulate = Color.yellow
	elif(health == 2):
		$Poolballsprite.modulate = Color.blue
	elif(health == 3):
		$Poolballsprite.modulate = Color.red
	elif(health == 4):
		$Poolballsprite.modulate = Color.orangered
	elif(health == 5):
		$Poolballsprite.modulate = Color.green
	elif(health == 6):
		$Poolballsprite.modulate = Color.brown
	elif(health == 7):
		$Poolballsprite.modulate = Color.maroon
	elif(health == 8):
		$Poolballsprite.modulate = Color.black

func _on_Tween_tween_completed(object, key):
	self.animations += 1
	if self.animations > 1 : 
		$"/root/main".spawn_rigid_poolball(self.position, self.velocity, self.health)
		self.remove_from_group("balls")
		get_parent().remove_child(self)
		queue_free()
	else : 
		var speed = velocity.length()
		$Tween.interpolate_property(self, "scale", (1 + int(is_boss1)) * max_size, 1.5 * Vector2.ONE,   0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	
	
