extends Node

#BIENVENIDO AL DIALOGO DE LA HISTORIA
#Script de cnoaraul
#Recuerda bloquear al personaje cuando este esté hablando

var operating=false
var speaking=false
var dialogos=["Eres nuestra única esperanza. Recibe nuestra bendicion, Te protegerá de los daños.",
"Vamos a empezar tu entrenamiento. Busca unos maniquies y atacalos hasta que mueran.",
"Cuando termines te trasportaremos a la base del Yggdrasil a cumplir tu destino."] # fin de la pelicula 


func startDialog():
	operating=true
	$ui/container/dialog_window_bottom.set_visible(true)
	sayD()
	pass


func dialogcounter():
	# Usa este script para definir quien está hablando
	
	if dialogos.size()==2:
		$ui/container/dialog_window_bottom/char_name.text="Dioses"
	if dialogos.size()==1:
		$ui/container/dialog_window_bottom/char_name.text="Dioses"
	if dialogos.size()==0:
		$ui/container/dialog_window_bottom/char_name.text="Dioses"
	pass


func sayD():
	#Dice cada texto de la pila hasta vaciarla
	if operating and dialogos!=[]:
		$ui/container/dialog_window_bottom/text.set_bbcode(dialogos.pop_front())
		$dialog_anim.play("new_dial")
		speaking=true
		dialogcounter()
	else:
		endConversation()
		pass
	pass

func endConversation():
	# Al finalizar con el dialogo se procede a jugar o a la accion que se haga
	
	$ui/container/dialog_window_bottom.set_visible(false)
	#$ui/chapter_tansition/transition_anim.play("exit_dialog")
	
	
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("ui_accept") and operating and not speaking:
		#Si el jugador pulsa accion y no se esta hablando procede al siguiente dialgo
		sayD()
		pass
	pass

func endScene():
	# Se termina el dialogo y se procede a jugar
	pass



func _ready():
	
	pass


func _on_dialog_anim_animation_finished(anim_name):
	if anim_name=="new_dial":
		speaking=false
		pass
	pass # Replace with function body.


func _on_transition_anim_animation_finished(anim_name):
	if anim_name=="enter":
		startDialog()
	if anim_name=="exit_dialog":
		endScene()
		pass
	pass # Replace with function body.
