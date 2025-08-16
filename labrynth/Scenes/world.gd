extends Node2D
@onready var player = $Node2D/CharacterBody2D
@onready var timer = $Timer
@onready var points = $CanvasLayer/Label
@onready var ui = $CanvasLayer
@onready var game_timer = $CanvasLayer/Label2
var portals: Array[Node]
var portable = true
var total_points = 0
var enemy_positions = []
var enemy_depth = []
var init_player_pos

var carrot_scene = preload("res://Scenes/carrot.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portals = get_tree().get_nodes_in_group("portal")
	for p in portals:
		p.teleport.connect(teleport)
	player.enemy_killed.connect(add_points)
	var carrots = get_tree().get_nodes_in_group("carrots")
	for c in carrots:
		enemy_positions.append(c.global_position)
		enemy_depth.append(c.layer)
	init_player_pos = player.global_position
		

func teleport():
	if portable == true:
		portable = false
		var location = portals.pick_random()
		var coords = location.global_position
		player.global_position = coords
		timer.start(1.0)
		player.switch_mask_layer(location.layer)
		player.z_index = location.layer +1
	

func _on_timer_timeout() -> void:
	portable = true
	
func add_points():
	total_points += 50
	points.text = "Points: " + str(total_points)


func _on_button_pressed() -> void:
	var carrots = get_tree().get_nodes_in_group("carrots")
	for c in carrots:
		c.queue_free()
	var ticker = 0
	for i in enemy_positions:
		var instance = carrot_scene.instantiate()
		instance.global_position = i
		instance.layer = enemy_depth[ticker]
		ticker += 1
		add_child(instance)
	player.game_pause = false
	total_points = 0
	points.text = "Points: " + str(total_points)
	game_timer.start_timer()
	ui.game_restart()
	player.global_position = init_player_pos


func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_gametimer_timeout() -> void:
	var carrots = get_tree().get_nodes_in_group("carrots")
	for c in carrots:
		c.game_pause = true 
	ui.game_end()
	player.game_pause = true
