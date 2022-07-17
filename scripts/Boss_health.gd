extends Control


onready var hp_bar = $health_bar
 
func _ready():
	hp_bar.value = 0

func change_value(hp):
	if $Tween.is_active():
		$Tween.stop_all()
	$Tween.interpolate_property(self.hp_bar, "value",hp_bar.value, hp, 3,Tween.TRANS_EXPO , Tween.EASE_OUT)
	$Tween.start()
