extends Node2D


var poolballsprite_res : Resource = preload("res://scenes/Poolballsprite.tscn") 
var poolball_res  : Resource = preload("res://scenes/Poolball.tscn") 

func _ready():
	randomize()
	$SpawnTimer.start()

func spawn( spawn_num ): 
	var spawns = $Spawns.get_children() 
	spawns.shuffle()
	spawn_num = min(spawn_num, 6)
		
	for i in range( spawn_num ) :
		var spawn_point = spawns[i]
		var init_dir = (- spawn_point.position).normalized()
		
		var poolballsprite = poolballsprite_res.instance()
		add_child(poolballsprite)
		poolballsprite.position = spawn_point.position + $Spawns.position
		poolballsprite.velocity = (1 + randf()) * 80 * init_dir
		poolballsprite.start_spawn_anim()

func spawn_rigid_poolball( pos , vel, hp) : 
	var poolball  = poolball_res.instance()
	add_child(poolball)
	poolball.set_linear_velocity( 1.2 * vel)
	poolball.position = pos
	poolball.set_health(hp)
	$SpawnTimer.start()
	
	
	


func _on_SpawnTimer_timeout():
	spawn(randi() % 6 + 1)
