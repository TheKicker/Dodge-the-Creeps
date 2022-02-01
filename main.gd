extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation");
	mob_spawn_location.offset = randi()

	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	add_child(mob)
	
	# After a while the game gets boring, so let's make it spicy
	# Original wait time is 0.75s
	if score > 30:
		# 2 mobs per second
		$MobTimer.wait_time = 0.5
	elif score > 45:
		# 3 mobs per second
		$MobTimer.wait_time = 0.333
	elif score > 60:
		# 4 mobs per second
		$MobTimer.wait_time = 0.25
	elif score > 90:
		# Haha good luck
		$MobTimer.wait_time = 0.1

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
