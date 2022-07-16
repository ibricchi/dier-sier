extends KinematicBody2D

var health: int;
var animations = 0
var velocity = Vector2.ZERO
var max_size = Vector2(1.6,1.6)

# Called when the node enters the scene tree for the first time.
func _ready():
	 
	health = randi() % 8;
	self.update_color()

func _process(delta):
	move_and_collide(velocity * delta)

func start_spawn_anim():
	scale = Vector2(0,0)
	var speed = velocity.length()
	$Tween.interpolate_property(self, "scale", Vector2.ZERO, max_size , 100 /speed * 0.6, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
 
func update_color():
	if(health == 1):
		self.modulate = Color.yellow
	elif(health == 2):
		self.modulate = Color.blue
	elif(health == 3):
		self.modulate = Color.red
	elif(health == 4):
		self.modulate = Color.orangered
	elif(health == 5):
		self.modulate = Color.green
	elif(health == 6):
		self.modulate = Color.brown
	elif(health == 7):
		self.modulate = Color.maroon
	elif(health == 8):
		self.modulate = Color.black

func _on_Tween_tween_completed(object, key):
	self.animations += 1
	if self.animations > 1 : 
		$"/root/main".spawn_rigid_poolball(self.position, self.velocity, self.health)
		get_parent().remove_child(self)
		queue_free()
	else : 
		var speed = velocity.length()
		$Tween.interpolate_property(self, "scale", max_size, Vector2.ONE,  100 / speed * 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	
	
