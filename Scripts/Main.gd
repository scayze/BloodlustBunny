extends Node

#UI Nodes
onready var ui_time = get_node("UI/Time")
onready var ui_level_finished = get_node("UI/LevelSuccess")
onready var ui_game_over = get_node("UI/GameOver")
onready var ui_game_finished = get_node("UI/GameSuccess")
onready var ui_stop = get_node("UI/Stop")
onready var ui_stop_time = get_node("UI/StopTimer")
onready var ui_game_start = get_node("UI/GameStart")

#Timers
var timer
var stop_timer 

#Game States
var stopped
var success
var started

#Levels
var levels = []
var current_level_idx = 0
var current_level

#Coutners
var enemies = 0

#Signals
signal game_stopped

func _ready():
	levels.append(preload("res://Levels/L1.tscn"))
	levels.append(preload("res://Levels/L4.tscn"))
	levels.append(preload("res://Levels/L3.tscn"))
	levels.append(preload("res://Levels/L2.tscn"))
	levels.append(preload("res://Levels/L5.tscn"))
	restart_game()
	ui_time.text = str(timer).pad_decimals(1)

func restart_game():
	current_level_idx = 0
	load_level(current_level_idx)
	
	ui_stop.disabled = false
	
	timer = 10
	stop_timer = 5
	
	stopped = false
	success = false
	started = false
	
	ui_game_start.visible = true
	ui_stop.pressed = false
	ui_stop.disabled = false
	ui_game_over.visible = false
	ui_level_finished.visible = false
	ui_stop_time.visible = false
	ui_game_finished.visible = false

func load_level(idx):
	if current_level:
		current_level.queue_free()
	current_level = levels[idx].instance()
	add_child(current_level)
	move_child(current_level,0)

func next_level():
	current_level_idx += 1
	load_level(current_level_idx)
	
	stop_timer = 5
	success = false
	started = false
	stopped = false
	
	ui_stop.pressed = false
	ui_game_start.visible = true
	ui_stop.disabled = false
	ui_game_over.visible = false
	ui_level_finished.visible = false
	ui_stop_time.visible = false

func level_success():
	success = true
	if current_level_idx == levels.size() - 1:
		ui_game_finished.visible = true
	else:
		ui_level_finished.visible = true

func _process(delta):
	if !success and started:
		if !stopped:
			timer -= delta
			if timer <= 0.0: timer = 0.0
		else:
			stop_timer -= delta
			if stop_timer <= 0.0: stop_timer = 0.0
			ui_stop_time.text = str(stop_timer).pad_decimals(1)
		if timer == 0.0 or stop_timer == 0.0:
			ui_game_over.visible = true
	ui_time.text = str(timer).pad_decimals(1)

func _on_Stop_pressed():
	emit_signal("game_stopped")
	ui_stop.disabled = true
	ui_stop_time.visible = true
	stopped = true

func _on_Next_pressed():
	next_level()

func _on_Retry_pressed():
	restart_game()

func carrot_collected():
	timer += 4

func add_enemy():
	enemies += 1

func enemy_dead():
	enemies -= 1
	if enemies <= 0:
		level_success()

func _on_Restart_pressed():
	restart_game()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	started = true
	ui_game_start.visible = false
