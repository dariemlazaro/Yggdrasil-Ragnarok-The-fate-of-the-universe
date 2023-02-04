extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Jugar_pressed():
	Global.goto_scene("res://Mundo/Principal.tscn")
	Global.player_pos = 0
	Global.noche = true
	Global.dia = false



func _on_Ver_Creditos_pressed():
	$Margen/Panel.show()


func _on_Atras_pressed():
	$Margen/Panel.hide()



func _on_Salir_pressed():
	get_tree().quit()

