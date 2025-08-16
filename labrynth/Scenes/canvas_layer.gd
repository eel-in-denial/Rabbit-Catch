extends CanvasLayer
@onready var end_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_rect.visible = false


func game_end():
	end_rect.visible = true

func game_restart():
	end_rect.visible = false
