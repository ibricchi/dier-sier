extends CanvasLayer

onready var game_scene: PackedScene = load("res://main.tscn")

func _on_play_button():
	state.hits = [0,0,0,0,0,0]
	state.damage = [0,0,0,0,0,0]
	state.super = [0,0,0,0,0,0]
	get_tree().change_scene_to(game_scene)
