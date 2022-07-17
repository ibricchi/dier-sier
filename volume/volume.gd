extends Control

func _ready():
	visible = false
	get_node("MarginContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/MarginContainer/HSlider").min_value = 0
	get_node("MarginContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/MarginContainer/HSlider").max_value = db2linear(10)
	get_node("MarginContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/MarginContainer/HSlider").step = db2linear(10) / 100
	get_node("MarginContainer/Panel/MarginContainer/VBoxContainer/MarginContainer2/MarginContainer/HSlider").value = state.volume
	

func _unhandled_input(event):
	if(event.is_action_pressed("ui_cancel")):
		visible = !visible
		get_tree().paused = !get_tree().paused

signal change_volume(value)
func _on_volume_change(value):
	emit_signal("change_volume", value)
