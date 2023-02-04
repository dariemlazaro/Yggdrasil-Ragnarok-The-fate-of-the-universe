extends Spatial

onready var joystick = Global.get_node("Touch/TouchButtons/Joystickcamara/control/stick")
var camrot_h = 0
var camrot_v = 0

var cam_v_min = -30#-10
var cam_v_max= 50

var h_sensitivity = 0.1
var v_sensitivity = 0.1

var ha_sensitivity = 2
var va_sensitivity = 2

var h_sensitivity_aim = 0.1#0.04
var v_sensitivity_aim = 0.1#0.04

var ha_sensitivity_aim = 1
var va_sensitivity_aim = 1

var h_acceleration = 10
var v_acceleration = 10


func _ready():
	$h/v/pivot/Camera.add_exception(get_parent())

#	$h/v/Camera.add_exception(get_parent())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	var is_aim = 0 #int(get_parent().accion == get_parent().acciones.APUNTAR)
	
	if event is InputEventMouseMotion and OS.get_name() != "Android":
		$RotateCamera.start()

		camrot_h += -event.relative.x * (h_sensitivity * (1-is_aim) + h_sensitivity_aim * is_aim )
		camrot_v += event.relative.y * (v_sensitivity * (1-is_aim) + h_sensitivity_aim * is_aim)
		
	if event is InputEventScreenDrag and joystick.get_value() == Vector2.ZERO:
		$RotateCamera.start()

		camrot_h += -event.relative.x * (h_sensitivity * (1-is_aim) + h_sensitivity_aim * is_aim )
		camrot_v += event.relative.y * (v_sensitivity * (1-is_aim) + h_sensitivity_aim * is_aim)
	
#		if joystick.get_value() != Vector2.ZERO:
#			$RotateCamera.start()
#
#			camrot_h += -joystick.get_value().x * (ha_sensitivity * (1-is_aim) + ha_sensitivity_aim * is_aim )
#			#camrot_v += joystick.get_value().y * (va_sensitivity * (1-is_aim) + va_sensitivity_aim * is_aim)


func _physics_process(delta):
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	if joystick.get_value() != Vector2.ZERO:
		var is_aim = int(get_parent().accion ==  get_parent().acciones.APUNTANDO)
		$RotateCamera.start()
		camrot_h += -joystick.get_value().x * (ha_sensitivity * (1-is_aim) + ha_sensitivity_aim * is_aim )
		camrot_v += joystick.get_value().y * (va_sensitivity * (1-is_aim) + va_sensitivity_aim * is_aim)
	
	if (Input.is_action_pressed("camara_arriba") || Input.is_action_pressed("camara_abajo") ||Input.is_action_pressed("camara_derecha") ||Input.is_action_pressed("camara_izquierda")) and joystick.get_value() == Vector2.ZERO:
		var is_aim = int(get_parent().accion ==  get_parent().acciones.APUNTANDO)
		$RotateCamera.start()
		camrot_h += -(Input.get_action_strength("camara_derecha") - Input.get_action_strength("camara_izquierda")) * (ha_sensitivity * (1-is_aim) + ha_sensitivity_aim * is_aim )
		camrot_v += (Input.get_action_strength("camara_abajo") - Input.get_action_strength("camara_arriba")) * (va_sensitivity * (1-is_aim) + va_sensitivity_aim * is_aim)
	
	var mesh_front = get_node("../mesh").global_transform.basis.z
	var rot_speed_multiplier = 0.15
	var auto_rotate_speed = (PI - mesh_front.angle_to($h.global_transform.basis.z)) * get_parent().velocity.length() * rot_speed_multiplier
	if $RotateCamera.is_stopped():# and is_aim == 0:
		if get_parent().is_on_floor():
			$h.rotation.y = lerp_angle($h.rotation.y, get_node("../mesh").global_transform.basis.get_euler().y, delta * auto_rotate_speed)
			camrot_h = $h.rotation_degrees.y
	else:
		$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)
	
