extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

 
func _process(delta):
	$Label.text = "Wave %s" % $"/root/main".wave_number
