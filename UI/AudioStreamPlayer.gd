extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$".".play()
	print("Loaded to: ", state.volume)
	set_volume_db(state.volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_settings_change_volume(value):
	state.volume = linear2db(value)
	print("Changed to: ", state.volume)
	set_volume_db(state.volume)
