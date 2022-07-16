extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		$hits.get_child(i).visible = false
	$death1.visible = false
	$death2.visible = false
	$death3.visible = false
	$dice_frame.texture = load("res://assets/dice_normal.png")
		
	pass # Replace with function body.

func update_gui(hits, damage, super):
	for i in range(hits):
		$hits.get_child(i).visible = true
	
	if damage == 1:
		$death1.visible = true
	elif damage == 2:
		$death1.visible = true
		$death2.visible = true
	elif damage == 3:
		$death1.visible = true
		$death2.visible = true
		$death3.visible = true
		
	if super == 0:
		$dice_frame.texture = load("res://assets/dice_normal.png")
	elif super == 1:
		$dice_frame.texture = load("res://assets/dice_super1.png")
	elif super == 2:
		$dice_frame.texture = load("res://assets/dice_super2.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
