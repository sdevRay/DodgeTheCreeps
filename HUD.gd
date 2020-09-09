extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(test):
	$Message.text = test
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# wait until the messagetimer has counted down
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the \nCreeps!"
	$Message.show()
	
	# make a one-shot timer and wait for it to finish	
	yield(get_tree().create_timer(1), "timeout")
	# When you need to pause for a brief time, an alternative to using a Timer node is to use the SceneTree's create_timer() function. This can be very useful to add delays such as in the above code, where we want to wait some time before showing the "Start" button.
	
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	

func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
