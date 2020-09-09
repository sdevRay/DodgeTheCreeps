extends Area2D
signal hit

# Using the export keyword on the first variable speed allows us to set its value in the Inspector.
export var speed = 400 #how fast the player will move (pixels/sec)
var screen_size # size of the game window

# this variable to hold the clicked position
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check for input
	var velocity = Vector2() # the players movement vector
	
	#move towards the target and stop when close
	if position.distance_to(target) > 10:
		velocity = target - position
#
#	if Input.is_action_pressed("ui_right"):	
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):	
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):	
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):	
#		velocity.y -= 1		
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		# $ is shorthand for get_node(). So in the code above, $AnimatedSprite.play() is the same as get_node("AnimatedSprite").play().
		
	position += velocity * delta
	
	# we still need to clamp the players position here because on devices that dont match your games aspect ratio, godot will try to maintain it as much as possbile by creating block borders. if necessary. without clamp() the player would be able to move under those borders
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)	
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	# move in the given direction
	# play the appropriate animation
	
	
#change the target whenever a touch event happens
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _on_Player_body_entered(body):
	hide() # player disappears after being hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	# Each time an enemy hits the player, the signal is going to be emitted. We need to disable the player's collision so that we don't trigger the hit signal more than once.
	# Disabling the area's collision shape can cause an error if it happens in the middle of the engine's collision processing. Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	
func start(pos):
	# initial target is the start position
	target = pos
	
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
