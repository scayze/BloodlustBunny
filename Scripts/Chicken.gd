extends RigidBody2D

var health
var max_health = 100

export(Texture) var healthy
export(Texture) var half
export(Texture) var full

onready var sprite = get_node("Sprite")

var textures = []

func _ready():
	contact_monitor = true
	contacts_reported = 4
	
	textures.clear()
	textures.resize(3)
	textures[0] = healthy
	textures[1] = half
	textures[2] = full
	
	connect("body_entered",self,"_body_entered")
	health = max_health
	get_tree().root.get_node("Main").add_enemy()

func _process(delta):
	if health < 0: sprite.modulate.a -= delta * 2.5
	if sprite.modulate.a <= 0.0: queue_free()
	if position.y > 750:
		get_tree().root.get_node("Main").enemy_dead()
		queue_free()

func impact(strength):
	print(strength)
	#get_node("CollisionShape2D").disabled = true
	health -= strength
	if health < 0:
		get_node("CollisionShape2D").disabled = true
		get_tree().root.get_node("Main").enemy_dead()
	
	var r = health / max_health
	if r < 0.33333: sprite.texture = textures[2]
	elif r < 0.666: sprite.texture = textures[1]
	elif r < 1.000: sprite.texture = textures[0]


func _body_entered(body):
	if body.is_in_group("tile"):
		body.impact(linear_velocity.length() * 0.75)
	elif !body.is_in_group("ball"):
		print("asd")
		impact(linear_velocity.length() * 0.75)
