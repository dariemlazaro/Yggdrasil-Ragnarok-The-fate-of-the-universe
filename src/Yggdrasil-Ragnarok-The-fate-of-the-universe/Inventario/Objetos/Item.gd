extends Node2D
onready var icon=$icon
onready var etiqueta=$count

var nombre 
var cantidad

func set_item(nombre_item, cantidad_item):
	nombre = nombre_item
	cantidad = cantidad_item

	
	icon.texture = load("res://Inventario/" + Jsondata.item_data[nombre]["Path"] + "/iconos/" + Jsondata.item_data[nombre]["Filename"] +".png")
	var cantidadpila= int(Jsondata.item_data[nombre]["MaxPila"])

	if cantidadpila == 1:
		etiqueta.visible= false
	else:
		etiqueta.visible= true
		etiqueta.text = String(cantidad)

func add_item(amount):
	cantidad += amount
	etiqueta.text = String(cantidad)
	
	icon.texture=load("res://Inventario/" + Jsondata.item_data[nombre]["Path"] + "/iconos/" + Jsondata.item_data[nombre]["Filename"] +".png")
	var cantidadpila= int(Jsondata.item_data[nombre]["MaxPila"])
	if cantidadpila == 1:
		etiqueta.visible= false
	else:
		etiqueta.text = String(cantidad)
	
	
	
func remove_item(amount):
	cantidad -= amount
	etiqueta.text = String(cantidad)
	
	
#func _process(delta):
#	pass
