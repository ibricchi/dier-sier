extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

 
func _process(delta):
	$Label.text = "Time: %s" % int(state.time)
