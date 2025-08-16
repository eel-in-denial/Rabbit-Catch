extends CharacterBody2D
class_name Carrot

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var layer = 3
@onready var timer = $Timer
@onready var area = $Area2D

var jump = false
var rand_direction = Vector2.ZERO
var vertical = 0
var gravity = 20
var game_pause = false

func _ready() -> void:
	for i in range(1, 9):
		set_collision_mask_value(i, false)
	set_collision_mask_value(layer, true)
	z_index = layer - 3
	timer.start()
	area.death.connect(die)

func _physics_process(delta: float) -> void:
	if game_pause == false:
		if jump == true:
			velocity = rand_direction * SPEED * delta * 60
			velocity.y -= vertical
			vertical -= gravity
			if vertical <= -300:
				jump = false
				vertical = 0
				velocity = Vector2.ZERO

	# Get the input direction and handle the movement/deceleration.
	# As good practic
	move_and_slide()


func _on_timer_timeout() -> void:
	jump = true
	vertical = 300
	var rand_angle = randf_range(0, TAU)
	rand_direction = Vector2(cos(rand_angle), sin(rand_angle))
	timer.start(randf_range(2.0, 4.0))
	
func die():
	queue_free()
