extends TouchScreenButton

var is_master = false

onready var boton = $Button

func _ready():
	self.normal = load("res://HUD/ScreenButtons/TouchButtons/mirilla_negra.png")

func _on_apuntar_pressed():
	if is_master:
		if !boton.pressed:
			boton.pressed = true
		else:
			boton.pressed = false

func _on_Button_toggled(button_pressed):
	
	if is_master:
		if button_pressed:
			var a = InputEventAction.new()
			a.action = "apuntar"
			a.pressed = true
			Input.parse_input_event(a)
			self.normal = load("res://HUD/ScreenButtons/TouchButtons/mirilla_roja.png")
		else:
			var a = InputEventAction.new()
			a.action = "apuntar"
			a.pressed = false
			Input.parse_input_event(a)
			self.normal = load("res://HUD/ScreenButtons/TouchButtons/mirilla_negra.png")
