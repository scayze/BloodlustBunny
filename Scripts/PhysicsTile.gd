extends RigidBody2D
tool

enum Mat {
	WOOD
	STONE
	EXPLOSIVE
}

export(Mat) var type = Mat.WOOD setget set_type

export var wood_health = 150
export var stone_health = 250
var health
var max_health

export(Texture) var wood1
export(Texture) var wood2
export(Texture) var wood3

export(Texture) var stone1
export(Texture) var stone2
export(Texture) var stone3

export(Texture) var explosive1
export(Texture) var explosive2
export(Texture) var explosive3

onready var sprite = get_node("Sprite")

var textures = []

func _ready():
	contact_monitor = true
	contacts_reported = 4
	connect("body_entered",self,"_body_entered")
	set_type(type)
	if type == Mat.WOOD or type == Mat.EXPLOSIVE:
		health = wood_health
		max_health = wood_health 
	elif type == Mat.STONE:
		health = stone_health
		max_health = stone_health

func _process(delta):
	if health < 0: sprite.modulate.a -= delta * 2.5
	if sprite.modulate.a <= 0.0: queue_free()

func impact(strength):
	health -= strength
	if health < 0: get_node("CollisionShape2D").disabled = true
	
	var r = health / max_health
	if r < 0.33333: sprite.texture = textures[2]
	elif r < 0.666: sprite.texture = textures[1]
	elif r < 1.000: sprite.texture = textures[0]


func _body_entered(body):
	if !body.is_in_group("tile"): return
	body.impact(linear_velocity.length() * 0.75)

func set_type(t):
	sprite = get_node("Sprite")
	if not sprite: return
	type = t
	textures.clear()
	textures.resize(3)
	if type == Mat.WOOD:
		textures[0] = wood1
		textures[1] = wood2
		textures[2] = wood3
	elif type == Mat.STONE:
		textures[0] = stone1
		textures[1] = stone2
		textures[2] = stone3
	elif type == Mat.EXPLOSIVE:
		textures[0] = explosive1
		textures[1] = explosive2
		textures[2] = explosive3
	else: return
	sprite.texture = textures[0]
