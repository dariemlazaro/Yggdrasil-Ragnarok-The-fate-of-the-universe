extends Node

#BIENVENIDO AL DIALOGO DE LA HISTORIA
#Script de cnoaraul
#Recuerda bloquear al personaje cuando este esté hablando

var operating=false
var speaking=false
var dialogos=["A ver el precio...","¿¡ 1200 MONEDAS !?","Ni q estuviera fresco","Seguro lo traen de un río estancado de por ahí"]


func startDialog():
	operating=true
	$ui/container/dialog_window_bottom.set_visible(true)
	sayD()
	pass


func dialogcounter():
	# Usa este script para definir quien está hablando
	#
	#if dialogos.size()==3:
	#	$ui/container/dialog_window_bottom/char_name="Personaje1"
	
	pass


func sayD():
	#Dice cada texto de la pila hasta vaciarla
	if operating and dialogos!=[]:
		$ui/container/dialog_window_bottom/text.set_text(dialogos.pop_front())
		$dialog_anim.play("new_dial")
		speaking=true
	else:
		endConversation()
		pass
	pass

func endConversation():
	# Al finalizar con el dialogo se procede a jugar o a la accion que se haga
	$ui/container/dialog_window_bottom.set_visible(false)
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("ui_accept") and operating and not speaking:
		#Si el jugador pulsa accion y no se esta hablando procede al siguiente dialgo
		sayD()
		pass
	pass


func _ready():
	#Comienza la escenaa
	3#startDialog()
	
	pass


func _on_dialog_anim_animation_finished(anim_name):
	if anim_name=="new_dial":
		speaking=false
		pass
	pass # Replace with function body.
