extends Control

var items = preload("res://Inventario/Objetos/Item.tscn")
const ItemClass = preload("res://Inventario/Objetos/Item.gd")
const SlotClass = preload("res://Inventario/Slot.gd")

onready var inventory_slots_objetos = $Margin/Popup/Grids/VBox/Lista

#informacion visual
onready var descripcion = $Margin/Popup/Grids/VBox/Descripcion
onready var monedas = $Margin/Popup/Grids/VBox/HBox/Dinero

var holding_item = null

#diccionarios
var dinero = 0

var item_list_objetos={
	0: ["Pocion de vida", 98],
	1: ["Pocion de energia", 54],
	2: ["Anillo basico", 1]
} 



func _ready():
	var inv_slots_objetos = inventory_slots_objetos.get_children()
	for i in range(inv_slots_objetos.size()):
		inv_slots_objetos[i].connect("gui_input", self, "slot_gui_input", [inv_slots_objetos[i]])
		inv_slots_objetos[i].connect("mouse_exited", self, "no_hover")
		inv_slots_objetos[i].slot_index = i

	initialize_inventory()

func initialize_inventory():
	monedas.text = str(Global.player_dinero)
	dinero = Global.player_dinero

	var inv_slots_objetos = inventory_slots_objetos.get_children()

	for i in range(inv_slots_objetos.size()):
		if item_list_objetos.has(i):
			inv_slots_objetos[i].initialize_item(item_list_objetos[i][0],item_list_objetos[i][1])


func slot_gui_input(event:InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#currently holding an item
			if holding_item != null:
					#empty slot
				if !slot.item: #place holding item to slot
					move_empty_slot(slot)
				#slot alredy contain an item
				else: 
					#diferent item, so swap
					if holding_item.nombre != slot.item.nombre:
						move_different_item(slot, event)
					#same item, so merge
					else:
						move_same_item(slot)
			#not holding an item
			elif slot.item:
				not_holding(slot)
#	if slot.item:
#		descripcion.text = str(Jsondata.item_data[slot.item.nombre]["Descripcion"])

#func no_hover():
#	descripcion.text = ""

func move_empty_slot(slot: SlotClass):
	add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null

func move_different_item(slot: SlotClass, event: InputEvent):
		
	remove_item(slot)
	add_item_to_empty_slot(holding_item, slot)

	var temp_item = slot.item
	slot.pickFromSlot()
#	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func move_same_item(slot: SlotClass):
	var cantidadpila= int(Jsondata.item_data[slot.item.nombre]["MaxPila"])
	var able_to_add = cantidadpila - slot.item.cantidad
	if able_to_add >= holding_item.cantidad:
		add_item_quantity(slot, holding_item.cantidad)
		slot.item.add_item(holding_item.cantidad)
		holding_item.queue_free()
		holding_item = null
	else:
		add_item_quantity(slot, able_to_add)
		slot.item.add_item(able_to_add)
		holding_item.remove_item(able_to_add)

func not_holding(slot: SlotClass):
	if slot.item.nombre != "blocked":
		remove_item(slot)
		holding_item = slot.item
		slot.pickFromSlot()
#		holding_item.global_position = get_global_mouse_position()
	
func add_item(nombre, cantidad):
	for item in item_list_objetos:
		if item_list_objetos[item][0] == nombre:
			var cantidadpila = int(Jsondata.item_data[nombre]["MaxPila"])
			var able_to_add = cantidadpila - item_list_objetos[item][1]
			if able_to_add >= cantidad:
				item_list_objetos[item][1] += cantidad
				return
			else:
				item_list_objetos[item][1] += able_to_add
				cantidad = cantidad - able_to_add
	#item does not exist in inventory
	for i in range(inventory_slots_objetos.get_child_count()):
		if item_list_objetos.has(i) == false:
			item_list_objetos[i] = [nombre, cantidad]
			return
					

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	item_list_objetos[slot.slot_index] = [item.nombre, item.cantidad]


func add_item_quantity(slot: SlotClass, amount):
	item_list_objetos[slot.slot_index][1] += amount


func remove_item(slot: SlotClass):
	item_list_objetos.erase(slot.slot_index)


func add_moneda(amount):
	Global.player_dinero += amount

#func _input(_event):
#	if holding_item:
#		holding_item.global_position = get_global_mouse_position()

