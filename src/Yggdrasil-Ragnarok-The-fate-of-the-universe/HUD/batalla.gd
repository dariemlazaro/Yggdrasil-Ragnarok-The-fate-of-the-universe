extends Node

export var operating=false
export var speaking=false
var intro_text=[
"Odín llega a los cimientos del Yggdrasil.",
"Cabalga hasta el pozo de Urd donde encuentra a Fenrir.",
"la batalla fué épica. Dos dioses se enfrentaron en una lucha sin cuartel.",
"Pero el destino es incierto y Fenrir resulta ser más poderoso que Odín quien se desvanece a la sombra del Yggdrasil.",
"Los dioses ofrecen el ojo restante de Odín al Águila anónima para obtener respuestas de como sobrevivir al Ragnarok.",
"La respuesta fue inesperada.",
"Solo queda una esperanza, un humano de voluntad pura, un lector incansable y un protector de la naturaleza, se funden en una sola alma en Midgard. Solo él podrá evitar la llegada del Ragnarok.",
"Los dioses cruzan el Bifrost a Midgard y buscan por cada aldea quien cumpla con la profecía del Águila. Ningún habitante cumplía con la profecía, excepto un infante.",
"Pero los dioses siguen buscando y no encuentran a más nadie. No quedó otra alternativa. Ese infante debía cargar con el peso del universo.",
"Los dioses lo entrenan y lo bendicen para aumentar las probabilidades de éxito, pero las dudas persisten.",
"Los dioses se preguntan como un simple mortal, un infante, podría desafiar la ira de los dioses y salir ileso.",
"El propio Odín con todo su poderío, vio su final ante el Fenrir. ¿Cual será el destino de un simple mortal jugando a ser Dios?"]


func startDialog():
	operating=true
	sayD()
	pass


func dialog_counter():
	if intro_text.size()==6:
		$ui/trans_container/trans_anim.play("exit_slow")
	if intro_text.size()==1:
		$ui/trans_container/trans_anim.play("enter")
	pass



func sayD():
	#Dice cada texto de la pila hasta vaciarla
	if operating and intro_text!=[]:
		$ui/container/text.set_text(intro_text.pop_front())
		$anim.play("write_intro_text")
		speaking=true
		dialog_counter()
	else:
		endConversation()
		pass
	pass

func endConversation():
	# Al finalizar con el dialogo se procede a jugar o a la accion que se haga
	Global.goto_scene("res://Mundo/Principal.tscn")
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("ui_accept") and operating and not speaking:
		#Si el jugador pulsa accion y no se esta hablando procede al siguiente dialgo
		sayD()
		pass
	pass


func _ready():
	#Comienza la escenaa
	startDialog()
	
	pass



func _on_anim_animation_finished(anim_name):
	if anim_name=="write_intro_text":
		speaking=false
		pass
	pass # Replace with function body.


func _on_trans_anim_animation_finished(anim_name):
	if anim_name=="enter":
		
		pass
	pass # Replace with function body.
