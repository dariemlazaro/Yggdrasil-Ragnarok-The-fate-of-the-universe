extends Node

export var operating=false
export var speaking=false
var intro_text=[
"El universo es un lugar caótico en constante cambio, creación y destrucción.",
"Entre tanto caos, un fresno perenne mantiene el equilibrio de nueve mundos, el Yggdrasil, el árbol de la vida.",
"Pasan eones y la balanza se inclina. Los mundos entran en guerras estúpidas por obtener riqueza y poder.",
"Sus desechos contaminan todo a su paso incluido el propio Yggdrasil.",
"Los mismísimos dioses discuten en sus salones sagrados y las asperezas se acumulan.",
"Fenrir, el lobo gigante es rechazado en el salón celestial y la rabia se apodera de él.",
"Se decide a destruir todo y a todos.",
"Se dirige al pozo de Urd, fuente de las aguas curativas que usan las nornas para sanar las raíces del gran fresno.",
"Se apoderá del lugar causando la muerte de varias nornas que trataron de defenderlo.",
"La nieve empieza a derretirse anunciando el fin del invierno y la llegada de la primavera, pero…"]


func startDialog():
	operating=true
	sayD()
	pass


func dialog_counter():
	if intro_text.size()==8:
		$ui/trans_container/trans_anim.play("exit_slow")
	if intro_text.size()==5:
		$enfasis.play()
	if intro_text.size()==3:
		$AnimationPlayer.play("fadeaudio")
		$enfasis2.play()
	if intro_text.size()==1:
		$AnimationPlayer.play("fadeaudio2")
		$enfasis3.play()
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
	Global.goto_scene("res://HUD/escena2_dialog.tscn")
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


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeaudio":
		$enfasis.stop()
	elif anim_name == "fadeaudio2":
		$enfasis2.stop()
	pass # Replace with function body.
