extends RigidBody2D

export var min_speed = 150 #min speed range
export var max_speed = 250 #max speed range

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	# First, we get the list of animation names from the AnimatedSprite's frames property. This returns an Array containing all three animation names: ["walk", "swim", "fly"].
	
	# We then need to pick a random number between 0 and 2 to select one of these names from the list (array indices start at 0). randi() % n selects a random integer between 0 and n-1.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
