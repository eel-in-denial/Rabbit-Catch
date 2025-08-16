extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
signal enemy_killed
@onready var animationPlayer = $AnimationPlayer
@onready var atk_collision = $swordArea/CollisionShape2D
var direction := Vector2.ZERO
var prev_direction := Vector2.ZERO
var attack = false
var atk_timer = 0
var curr_layer = 0
var game_pause = false

func _ready() -> void:
	atk_collision.disabled = true

func _physics_process(delta: float) -> void:
	if game_pause == false:
		direction = Input.get_vector("left", "right", "up", "down")
		if attack:
			atk_timer -= delta
			if atk_timer < 0:
				attack = false
		elif Input.is_action_just_pressed("axe"):
			attack = true
			atk_timer = .9
			velocity = Vector2.ZERO
			if prev_direction.x > 0:
				animationPlayer.play("axe_right")
			elif prev_direction.x < 0:
				animationPlayer.play("axe_left")
			elif prev_direction.y > 0:
				animationPlayer.play("axe_down")
			elif prev_direction.y < 0:
				animationPlayer.play("axe_up")
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		elif direction:
			prev_direction = direction
			velocity = direction * SPEED * delta * 60
			if direction.x > 0:
				animationPlayer.play("run_right")
			elif direction.x < 0:
				animationPlayer.play("run_left")
			elif direction.y > 0:
				animationPlayer.play("run_down")
			elif direction.y < 0:
				animationPlayer.play("run_up")
		elif attack == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			if prev_direction.x > 0:
				animationPlayer.play("idle_right")
			elif prev_direction.x < 0:
				animationPlayer.play("idle_left")
			elif prev_direction.y > 0:
				animationPlayer.play("idle_down")
			elif prev_direction.y < 0:
				animationPlayer.play("idle_up")
		
		move_and_slide()
		

func switch_mask_layer(num:int):
	set_collision_mask_value(curr_layer+3, false)
	set_collision_mask_value(num+3, true)
	curr_layer = num


func _on_sword_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.die()
		enemy_killed.emit()
		
