extends Panel

var default_texture = preload("res://Inventario/iconos/slot.png")
var empty_texture = preload("res://Inventario/iconos/slot_empty.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var slot_index
var itemclass = preload("res://Inventario/Objetos/Item.tscn")
var item = null



func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	
	refresh_style()

func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventario")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("Inventario")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
	
func initialize_item(nombre, cantidad):
	if item == null:
		item = itemclass.instance()
		add_child(item)
		item.set_item(nombre, cantidad)
	else:
		item.set_item(nombre, cantidad)
	refresh_style()
	
