extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Restart_button_down():
	state.hits = [0,0,0,0,0,0]
	state.damage = [0,0,0,0,0,0]
	state.super = [0,0,0,0,0,0]
	state.points = 0
	state.wave = 0
	get_tree().change_scene_to(state.game_scene)
