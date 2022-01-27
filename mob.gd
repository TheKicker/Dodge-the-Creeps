extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	# Make an array of all the animation types, pick one at random to spawn
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
# When enemies leave the playing field they disappear
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
