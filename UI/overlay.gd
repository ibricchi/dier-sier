extends Control

var points: Array
var damage: Array

func _ready():
	var points_container = get_node("mc/hb/points/list")
	var damage_container = get_node("mc/hb/damage/list")
	for i in 6:
		points.push_back(points_container.get_child(i+1).get_child(2))
		damage.push_back(damage_container.get_child(i+1).get_child(2))
	state.connect("reload_overlay", self, "_on_reload_overay")

func to_tally(num):
	var tally: String = ""
	for i in num / 5:
		tally += "5"
	tally += str(num%5)
	return tally

func _on_reload_overay():
	for i in 6:
		points[i].set_text(to_tally(state.points[i]))
		damage[i].set_text(to_tally(state.damage[i]))
