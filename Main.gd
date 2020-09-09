extends Node


export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	# The call_group() function calls the named function on every node in a group - in this case we are telling every mob to delete itself.
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_MobTimer_timeout():
	# choose a random location on path2d
	$MobPath/MobSpawnLocation.offset = randi()
	# create a mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	# set the mobs direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# set the mobs position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	# add some randomness to the direction
	# Why PI? In functions requiring angles, GDScript uses radians, not degrees.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# set the velocity (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)	

# In _on_MobTimer_timeout(), we will create a mob instance, pick a random starting location along the Path2D, and set the mob in motion. The PathFollow2D node will automatically rotate as it follows the path, so we will use that to select the mob's direction as well as its position.

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
