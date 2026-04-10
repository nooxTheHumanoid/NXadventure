extends ProgressBar


func _ready() -> void:
	value = global.tempkills*5


func _process(_delta: float) -> void:
	value = global.tempkills*5
	if value >= 101:
		value = 100
