extends KinematicBody2D

#nodos
onready var inventario = Global.get_node("UI/HUD/Margin/Inventario")
onready var bolsa = Global.get_node("UI/HUD/Margin/Margin/VBox/experiencia/Margin/HBox/TextureRect/Position")
onready var canvas = Global.get_node("UI/HUD")


var lv = 1
var cantidad = 1
var acceleration = 460
var velocity = Vector2.ZERO
const speed = 600

var player = null
var being_picked_up = false
var move = false

func _ready():
	if !being_picked_up:
		cantidad = int(rand_range((lv*5),(lv*5) + 10))



func pick_up_item(body):
	if !being_picked_up:
		player = body
		$CollisionShape2D.set_deferred("disabled", true)
		canvas.add_moneda(cantidad, player.get_global_transform_with_canvas())
		self.queue_free()

func _process(delta):
	if being_picked_up:
		var direction = global_position.direction_to(bolsa.global_position)
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		var distance = global_position.distance_to(bolsa.global_position)
		if distance < 6:
			bolsa.get_parent().texture_normal = load("res://Inventario/Ropas/Bolsa/bolsa_icono_open.png")
			velocity= Vector2.ZERO
			inventario.add_moneda(cantidad)
			inventario.initialize_inventory()
			$AnimationPlayer.play("pickup")
			set_process(false)
			#queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pickup":
		bolsa.get_parent().texture_normal = load("res://Inventario/Ropas/Bolsa/bolsa_icono.png")
		queue_free()

