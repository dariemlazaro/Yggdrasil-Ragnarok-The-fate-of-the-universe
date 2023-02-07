extends KinematicBody

var is_ready = false

onready var mundo = get_parent()
onready var mesh=$mesh
#onready var proyectiles = $mesh/proyectiles
onready var camara = $camroot/h/v/pivot/Camera
onready var raycast = $camroot/h/v/pivot/Camera/RayCast
var ray_tip = Vector3.ZERO

onready var touchbuttons = Global.get_node("Touch/TouchButtons")
onready var apuntartouch = Global.get_node("Touch/TouchButtons/apuntar")
#variables de control
onready var joystick= Global.get_node("Touch/TouchButtons/Joystick/control/stick")


#move
var direction = Vector3.BACK
var last_direction = Vector3.BACK
var movement_speed = 0
var run_speed = 4
var velocity = Vector3.ZERO
var acceleration = 6
var friction = 3
var angular_acceleration = 7
var vertical_velocity = 0
var jump_velocity = 15
var gravity = 3#2

#saltos perfectos
var max_jump_velocity
var min_jump_velocity
var max_jump_heigth = 0.2#1.3
var min_jump_heigth = 0.2 * 10#10
var jump_duration = 0.5
var max_jumps = 1
var jumpcount = max_jumps




enum acciones {
	REPOSO,
	CAMINAR,
	CORRER,
	ESPRINTAR,
	RODAR,
	APUNTANDO
	}
	
var accion = acciones.CAMINAR
enum estados {
	NORMAL,
	ENGUARDIA,
	}
	
var estado= estados.NORMAL

#estado del personaje
onready var animation = $AnimationTree
onready var tween = $Tween
var max_vida = 100
var vida = 100
var animated_vida = 100
var firstmove = false
var aiming = false
var corriendo = false
var corria = false
var rolling = false
var falling = false

#combos
var hit=0
var atkstr=""
var bloqueado = false
var blocking = false
var attacking=false
var actions=[]


#proyectiles
var fireballs = []
func _ready():
	gravity = 2 * max_jump_heigth / pow(jump_duration, 2)
	max_jump_velocity = -jump_duration * gravity
	min_jump_velocity = -sqrt(2 * gravity * min_jump_heigth)
	jump_velocity = max_jump_velocity
	animation.active = true
	is_ready = true
#	touchbuttons.show()


func _physics_process(delta):
	ataque(delta)
	moviendo(delta)

var t = 0.0


func moviendo(delta):
	t += delta
	
	if Input.is_action_pressed("bloquear"):
		animation.set("parameters/block_blend/blend_amount", lerp(animation.get("parameters/block_blend/blend_amount"), 1, delta * acceleration))
		blocking = true
		$Rotate.start()
		mesh.global_transform.basis = $camroot/h.global_transform.basis
	else:
		animation.set("parameters/block_blend/blend_amount", lerp(animation.get("parameters/block_blend/blend_amount"), 0, delta * acceleration))
		blocking = false
	if Input.is_action_just_pressed("rodar") and $roll_timer.is_stopped():
		$roll_timer.start()
		animation.set("parameters/rodar/active", true)

	
	if Input.is_action_pressed("correr"):
		corriendo = true
		corria = true
	else:
		corriendo = false
		if $roll_timer.is_stopped():
			corria = false
		
	if (Input.is_action_pressed("adelante") || Input.is_action_pressed("atras") || Input.is_action_pressed("izquierda") || Input.is_action_pressed("derecha")) and animation.get("parameters/ataque/active") == false:
		
		friction = 1
		if !firstmove:
			firstmove = true
		var h_rot = $camroot/h.global_transform.basis.get_euler().y
		direction = Vector3(Input.get_action_strength("izquierda") - Input.get_action_strength("derecha"), 
							0, Input.get_action_strength("adelante") - Input.get_action_strength("atras")).rotated(Vector3.UP, h_rot).normalized()
		if corriendo == false:
			movement_speed = run_speed
			if is_on_floor():
				animation.set("parameters/iwr_blend/blend_amount", lerp(animation.get("parameters/iwr_blend/blend_amount"), 0, delta * acceleration))
		
		else:
			movement_speed = run_speed * 3
			if is_on_floor():
				animation.set("parameters/iwr_blend/blend_amount", lerp(animation.get("parameters/iwr_blend/blend_amount"), 1, delta * acceleration))
	elif (joystick.get_value() != Vector2.ZERO):
		friction = 1
		if !firstmove:
			firstmove = true
		
		var h_rot = $camroot/h.global_transform.basis.get_euler().y
		direction = Vector3(-joystick.get_value().x,0,-joystick.get_value().y).rotated(Vector3.UP, h_rot).normalized()
		if corriendo == false and is_on_floor():
			movement_speed = run_speed
			
		elif corriendo == true and is_on_floor():
			movement_speed = run_speed * 3
		
	elif not $roll_timer.is_stopped():
		if is_on_floor():
			friction = 20
			direction = Vector3(0,0,1).rotated(Vector3.UP, mesh.rotation.y).normalized()
			
			if corria == false :
				movement_speed = run_speed * 2
				
			elif corria == true:
				movement_speed = run_speed * 1.8
		else:
			animation.set("parameters/saltar/active", false)
	else:
		if $roll_timer.is_stopped():
			movement_speed = 0
			friction = 1
		if animation.get("parameters/rodar/active") == false and is_on_floor():
			animation.set("parameters/iwr_blend/blend_amount", lerp(animation.get("parameters/iwr_blend/blend_amount"), -1, delta * acceleration))

	if animation.get("parameters/ataque/active") == false:
		velocity = lerp(velocity , direction * movement_speed, delta * friction * acceleration)
		velocity = move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	
	if !is_on_floor():
		if $fall_timer.is_stopped() and !falling:
			$fall_timer.start()
		vertical_velocity += gravity * delta
		
	else:
		if get_floor_normal().y != 1:
			vertical_velocity = 0
		$fall_timer.stop()
		jumpcount = max_jumps
		if $Altura.is_colliding() and falling:
			falling = false

			if animation.get("parameters/ataque/active") == false:
				animation.set("parameters/saltar/active", true)
		
		elif animation.get("parameters/saltar/active") == false and animation.get("parameters/saltar/active") == false:
			falling = false
			
		#vertical_velocity = 0
	if firstmove and $Rotate.is_stopped() and movement_speed != 0:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)


func ataque(_delta):

	if Input.is_action_just_pressed("atacar") and hit < 1 and is_on_floor():
		hit+=1
		$atack_timer.start()
		if animation.get("parameters/ataque/active") == false:
			animation.set("parameters/ataque/active", true)

	if animation.get("parameters/ataque/active") == true:
		friction = 20

		

	if $atack_timer.is_stopped():
		$mesh/Armature/Skeleton/BoneAttachment2/AXE/ataque/CollisionShape.disabled = true
		if hit > 0 and animation.get("parameters/ataque/active") == false:
			attacking=true
			atkstr=""
			hit=0
			actions=[]

func receive_fireball():
	for eachfireball in fireballs:
		eachfireball.get_parent().remove_child(eachfireball)
		mesh.add_child(eachfireball)
		
func respawn(pos):
	self.global_transform.origin = pos
	self.visible = true
	vida = 100
	animated_vida = 100


func _on_fall_timer_timeout():
	falling = true
	pass # Replace with function body.





func _on_ataque_area_entered(_area):
	$mesh/Armature/Skeleton/BoneAttachment2/AXE/ataque/CollisionShape.disabled = true
	pass # Replace with function body.
