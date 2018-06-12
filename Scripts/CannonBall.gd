extends RigidBody2D


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_CannonBall_body_entered(body):
	if body.is_in_group("chicken"):
		body.impact(linear_velocity.length() * 2)
	if body.is_in_group("tile"):
		body.impact(linear_velocity.length())