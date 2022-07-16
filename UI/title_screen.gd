extends CanvasLayer

const game_scene: PackedScene = preload("res://main.tscn")

func _on_play_button():
	get_tree().change_scene_to(game_scene)
