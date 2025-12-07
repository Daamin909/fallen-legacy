extends CanvasLayer

@onready var top_lid = $TopLid
@onready var bottom_lid = $BottomLid

@export var blink_time := 0.18
@export var hold_time := 0.2

func _ready():
	# Start with a full blink and open (good for unconscious scene)
	blink_open_sequence()

func blink_open_sequence():
	await blink_close()
	await get_tree().create_timer(hold_time).timeout
	await blink_open()
	# You can call another blink here if you want:
	# await get_tree().create_timer(0.4).timeout
	# await blink_close()
	# await blink_open()

func blink_close():
	var tween = create_tween()
	tween.tween_property(top_lid, "position:y", 0, blink_time)
	tween.tween_property(bottom_lid, "position:y", 0, blink_time)
	return tween.finished

func blink_open():
	var h = top_lid.size.y
	var tween = create_tween()
	tween.parallel().tween_property(top_lid, "position:y", -h, blink_time)
	tween.parallel().tween_property(bottom_lid, "position:y", h, blink_time)
	return tween.finished
