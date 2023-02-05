extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$bottom_container/main_actions/item1/button_play.connect("pressed",self,"_on_Jugar_pressed")
	$bottom_container/main_actions/item3/btn_github.connect("pressed",self,"openGithub")
	$credits_screeen/button_back.connect("pressed",self,"_on_Atras_pressed")
	$bottom_container/main_actions/item2/button_credits.connect("pressed",self,"_on_Ver_Creditos_pressed")
	$credits_screeen/social_list/itm/button_fb.connect("pressed",self,"opensocialFb",["raul"])
	$credits_screeen/social_list/itm2/button_twit.connect("pressed",self,"opensocialTw",["raul"])
	$credits_screeen/social_list_dariem/itm/button_fb.connect("pressed",self,"opensocialFb",["dariem"])
	$credits_screeen/social_list_dariem/itm2/button_twit.connect("pressed",self,"opensocialTw",["dariem"])
	
	pass # Replace with function body.




func _on_Jugar_pressed():
	Global.goto_scene("res://HUD/intro_dialog.tscn")
	Global.player_pos = 0
	Global.noche = true
	Global.dia = false

func openGithub():
	OS.shell_open("https://github.com/dariemlazaro/Yggdrasil-Ragnarok-The-fate-of-the-universe")
	pass

func opensocialFb(user):
	if user=="raul":
		OS.shell_open("https://www.facebook.com/cnoaraulgames")
	if user=="dariem":
		OS.shell_open("https://www.facebook.com/dariemlazaro")
	pass

func opensocialTw(user):
	if user=="raul":
		OS.shell_open("https://twitter.com/cnoaraulgames")
	if user=="dariem":
		OS.shell_open("https://twitter.com/dariemlazaro")
	pass



func _on_Ver_Creditos_pressed():
	$credits_screeen.show()


func _on_Atras_pressed():
	$credits_screeen.hide()



func _on_Salir_pressed():
	get_tree().quit()

