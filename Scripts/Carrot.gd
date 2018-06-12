extends Area2D

var collected = false

func _process(delta):
	if collected:
		modulate.a -= delta*2.5


func _on_Carrot_body_entered(body):
	if body.is_in_group("ball"):
		get_tree().root.get_node("Main").carrot_collected()
		get_node("CollisionShape2D").disabled = true
		collected = true
