extends Node

export var operating=false
export var speaking=false
var intro_text=["Continurá..."]


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
