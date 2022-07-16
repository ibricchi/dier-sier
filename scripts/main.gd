extends Node2D


var poolballsprite_res : Resource = preload("res://scenes/Poolballsprite.tscn") 
var poolball_res  : Resource = preload("res://scenes/Poolball.tscn") 

var wave_number = 0
export var wave_cooldown : int = 40 

func _ready():
	randomize()
	$SpawnTimer.wait_time = wave_cooldown
	$SpawnTimer.start()

func spawn_wave( ): 
	# maybe have a UI thing indicating the wave number 
	
	wave_number += 1 
	wave_cooldown += 2.5
	$SpawnTimer.wait_time = wave_cooldown
	var spawns = $Spawns.get_children() 
	spawns.shuffle()
	var spawn_num : int = min( int( randf() * wave_number) + 1, 6)
		
	for i in range( spawn_num ) :
		var spawn_point = spawns[i]
		var init_dir = (- spawn_point.position).normalized()
		
		var poolballsprite = poolballsprite_res.instance()
		add_child(poolballsprite)
		poolballsprite.set_health( 1 + (randi() % wave_number)/ 3 )
		poolballsprite.position = spawn_point.position + $Spawns.position
		poolballsprite.velocity = (1 + randf()) * 80 * init_dir
		poolballsprite.start_spawn_anim()
		yield(get_tree().create_timer(0.5), "timeout")
	 
	yield(get_tree().create_timer(0.75), "timeout")
	var spawn_point = spawns[randi()%6]
	var init_dir = (- spawn_point.position).normalized()
	
	var poolballsprite = poolballsprite_res.instance()
	add_child(poolballsprite)
	poolballsprite.set_health( min(wave_number , 8))
	poolballsprite.position = spawn_point.position + $Spawns.position
	poolballsprite.velocity = (1 + randf()) * 100 * init_dir
	poolballsprite.start_spawn_anim()
	
	$SpawnTimer.start()

func spawn_rigid_poolball( pos , vel, hp) : 
	var poolball  = poolball_res.instance()
	add_child(poolball)
	poolball.set_linear_velocity( 1.2 * vel)
	poolball.position = pos
	poolball.set_health(hp)
	
	
func _process(delta):
	if get_tree().get_nodes_in_group("balls").empty() and $SpawnTimer.wait_time > 2  : 
		$SpawnTimer.stop()
		$SpawnTimer.set_wait_time(1)
		$SpawnTimer.start()
		
		 
		
	 


func _on_SpawnTimer_timeout():
	spawn_wave()
