extends Label

@onready var timer = $gametimer
var minutes: int
var seconds: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	minutes = timer.time_left / 60
	seconds = int(timer.time_left) % 60
	if seconds > 9:
		text = "Time: " + str(minutes) + ":" + str(seconds)
	else:
		text = "Time: " + str(minutes) + ":0" + str(seconds)

func start_timer():
	timer.start(300)
	minutes = timer.time_left / 60
	seconds = int(timer.time_left) % 60
	if seconds > 9:
		text = "Time: " + str(minutes) + ":" + str(seconds)
	else:
		text = "Time: " + str(minutes) + ":0" + str(seconds)
	
