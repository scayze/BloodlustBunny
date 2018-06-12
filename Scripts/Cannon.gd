extends Node2D

var dragging = false
var click_area = Vector2(30,60)

var strength_multi = 2.25
var max_dist = 275
var max_extension = 7

var scene_cannonball = preload("res://Scenes/CannonBall.tscn")
onready var sprite = get_node("Shooty")


func _ready():
	get_tree().root.get_node("Main").connect("game_stopped",self,"game_stopped")

func _process(delta):
	if get_viewport().get_mouse_position().x < 0 or get_viewport().get_mouse_position().y < 0:
		if dragging:
			shoot()
			dragging = false
	
	if dragging:
		var dist = (get_viewport().get_mouse_position() - global_position).length()
		dist = clamp(dist,0,max_dist)
		var r = dist / max_dist
		sprite.offset.x = -29 + r*max_extension
		
		sprite.rotation = get_viewport().get_mouse_position().angle_to_point(global_position)
		sprite.rotation = clamp(sprite.rotation,-1,0)

func game_stopped():
	click_area = Vector2(0,0)
	modulate = Color(0.7,0.7,0.7)

func shoot():
	print("shoot cannon")
	sprite.offset.x = -29
	var c = scene_cannonball.instance()
	get_parent().add_child(c)
	var shoot_pos = get_node("Shooty/ShootPos").global_position
	c.global_position = shoot_pos
	var impulse = (get_viewport().get_mouse_position() - global_position).clamped(max_dist) * strength_multi
	c.apply_impulse(Vector2(0,0),impulse)

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.is_pressed():
				if abs(global_position.x - ev.position.x) < click_area.x and abs(global_position.y - ev.position.y) < click_area.y:
					dragging = true
					print("start dragging cannon")
			else:
				if dragging:
					dragging = false
					shoot()