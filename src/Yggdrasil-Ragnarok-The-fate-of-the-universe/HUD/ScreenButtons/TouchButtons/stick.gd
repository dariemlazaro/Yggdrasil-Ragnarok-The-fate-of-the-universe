extends TouchScreenButton
var area = 75
var limite = 55
var touchevent
var drag = -1
var deadzone = 20

var ready = false

func _ready():
	set_process_input(false)
	get_parent().position = Vector2.ZERO

func _input(event):

	if (event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed())) and touchevent:
		var dist_center = (event.position - get_parent().get_parent().global_position).length()
		if dist_center <= area * global_scale.x or event.get_index() == drag:
			get_parent().set_global_position(event.position * global_scale)
			if get_parent().position.length() > limite:
				get_parent().set_position(get_parent().position.normalized() * limite)
			drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == drag:
		drag = -1

func _process(delta):
	if is_visible_in_tree():
		set_process_input(true)
	else:
		set_process_input(false)
	if drag == -1:
		get_parent().set_position(get_parent().position.move_toward(Vector2.ZERO, 250 * delta))


func get_value():
	if get_parent().position.length() > deadzone:
		return get_parent().position.normalized()
	return Vector2.ZERO


func _on_stick_pressed():
	touchevent = true


func _on_stick_released():
	touchevent = false
