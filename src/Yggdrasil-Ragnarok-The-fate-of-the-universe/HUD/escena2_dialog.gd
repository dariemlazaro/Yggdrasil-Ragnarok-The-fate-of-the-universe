extends Node

#BIENVENIDO AL DIALOGO DE LA HISTORIA
#Script de cnoaraul
#Recuerda bloquear al personaje cuando este esté hablando

var operating=false
var speaking=false
var dialogos=[
"Ya el invierno llega a su fin. Pronto se derretirá la nieve y florecerán los campos.", # Odín # 29 l
"??????........", # Odín
"¿¡Este charco de agua!?", # Odín
"¡No puede ser!, ¡No ahora!, ¡No cuando todo iba tan bien!", # otra vez Odín
"¡¡¡SE HA CONGELADO!!!", # ya callate Odín
"Un invierno seguido de otro. ¿Será la llegada del [b]Gran invierno[/b]?", #Nooo... seguro es la del verano Odín
"Debo consultar con urgencia al [b]Águila anónima[/b].", # No será mejor a Duolingo?? 
"Esperaba tu llegada, caballero oscuro. Las respuestas que buscan tienen un precio alto.", # Comienza a hablar el pollo, digo, el aguila l21
"¿De qué hablas? ¿Ni siquiera te he preguntado nada?", # el "Santa" nórdico alias Odín l20
"¡Pero lo preguntarás! [b]Pasado, Presente y Futuro[/b] convergen en este árbol y solo mis ojos pueden verlo todo.", #Aguila kawaii l19
"¡Entonces ya debes conocer sobre la llegada del [b]Gran invierno[/b]!", # Odín l18
"En efecto. Tus ojos es lo que pido a cambio del conocimiento. Eso claro, si quieres conocer el futuro que aguarda al universo. ", # Aguila l17
"Sin ojos no puedo defender [b]los 9 mundos[/b] enlazados a este árbol. Te ofrezco un trato.", # Odín l16
"Uno de mis ojos puedo ofrecer, pero no más. Tengo responsabilidades muy importantes.", # Odín no lo hagas :'( l15
"¡Por supuesto, solo uno! ¡ujummm!. Ya lo sabía desde el comienzo.", # Eres águila o cuervo?? l14
"¡¡¡AHHRRGG!!! To…toma, aquí tienes. Uno de mis ojos. [b]Ahora revélame el futuro[/b].", # Odín l13
"Debo admitirlo tienes agallas… Voy a ello.", # Aguila l12
"El [b]Yggdrasil[/b] ha perdido su equilibrio natural y han enfermado sus raíces. ", # Aguila l11
"El veneno de [b]Nidhoggr[/b], la serpiente atrapada entre sus raíces, los gusanos, que intentan pudrirlas, y los dragones que las convierten en carbón hacen mucho daño a estas. ",
"Si le sumas la contaminación ambiental, el cambio climático y las guerras sin sentido del reino de [b]Midgard[/b], son muchos los daños constantes a la salud del fresno.",
"Aún así las nornas mantenían el equilibrio, sanando las raíces con agua curativa del pozo de [b]Urd[/b]. ",
"Hasta que [b]un lobo enfurecido[/b] asesinó a varias de ellas y les impide acceder a tan vital recurso. [b]Fenrir[/b] ha perdido los cabales.",
"No solo ha llegado el [b]Gran invierno[/b]. [b]El Ragnarok[/b] se abalanza entre las ilusiones del tiempo.",
"[b]Presente… Pasado… Futuro… Los 9 mundos… TODO desaparecerá para siempre.[/b]",
"Debo detener a [b]Fenrir[/b] a toda costa. ", # ODIN 
"No te apresures… los engranajes ya han empezado a moverse, pero esta vez no formas parte de ellos.", # lechuza d Cubaeduca
"¿Qué dices? Es mi responsabilidad, debo detenerlo. ¡Gracias!", # Odin
"No me lo agradezcas. Después de todo solo ha sido [b]un intercambio[/b]. Adiós [b]Odin[/b], Adiós.", # aguila
"Adiós. Me dirijo a una batalla." ] # fin de la pelicula 


func startDialog():
	operating=true
	$ui/container/dialog_window_bottom.set_visible(true)
	sayD()
	pass


func dialogcounter():
	# Usa este script para definir quien está hablando
	#
	if dialogos.size()==28:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==21:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==20:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==19:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==18:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==17:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==16:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==15:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==14:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==13:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==12:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==4:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==3:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==2:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
	if dialogos.size()==1:
		$ui/container/dialog_window_bottom/char_name.text="Águila anónima"
	if dialogos.size()==0:
		$ui/container/dialog_window_bottom/char_name.text="Odín"
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
	$ui/chapter_tansition/transition_anim.play("exit_dialog")
	
	
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("ui_accept") and operating and not speaking:
		#Si el jugador pulsa accion y no se esta hablando procede al siguiente dialgo
		sayD()
		pass
	pass

func endScene():
	# Se termina el dialogo y se procede a jugar
	Global.goto_scene("res://HUD/batalla.tscn")
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
