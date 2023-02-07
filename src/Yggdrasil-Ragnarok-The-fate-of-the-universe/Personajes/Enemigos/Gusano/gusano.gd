extends KinematicBody

var count = 0
var gusanofirst = preload("res://Personajes/Enemigos/Gusano/pedazogusano1.tscn")
var gusanosecond = preload("res://Personajes/Enemigos/Gusano/pedazogusano2.tscn")
onready var poso = $mesh/Armature/Esqueleto/Skeleton/dead#/Position3D
onready var poss = $mesh/Armature/Esqueleto/Skeleton/dead2#/Position3D

#navigation
onready var agent : NavigationAgent = $agent
onready var next = agent.get_next_location()

#end navigation

var knockback = Vector3.ZERO
export (int) var vida_maxima = 2
onready var vida = vida_maxima
onready var first_position = global_transform.origin
onready var target_position = global_transform.origin
var wander_range = 20
var firstmove = false

#nodos
onready var damage_area = $mesh/damage
onready var damage_col = $mesh/damage
onready var ataque_area = $mesh/ataque
onready var ataque_col = $mesh/ataque/CollisionShape
onready var persecution_area = $mesh/persecution
onready var persecution_col = $mesh/persecution/CollisionShape
onready var mesh = $mesh
var player = null
var thisplayer = null
onready var animation = $AnimationTree

#valores
var velocity = Vector3.ZERO
var direction = Vector3.ZERO
export (int) var movement_speed = 4
export (int) var acceleration = 6
export (int) var angular_acceleration = 7
export (int) var friction = 2

var vertical_velocity = 0
var jump_velocity = 30
var gravity = 3#2

#saltos perfectos
var max_jump_velocity
var min_jump_velocity
var max_jump_heigth = 2
var min_jump_heigth = 1
var jump_duration = 0.5
var max_jumps = 1
var jumpcount = max_jumps

#estatus
var level = 1
var ataque=10
var defensa=1
var experiencia = 500

enum {
	IDLE
	WANDER,
	CHASE,
	ATTACK,
	DEAD
}
var state = IDLE

#drop
#var item = preload("res://Inventario/Objetos/Itemdrop.tscn").instance()
#var itemlist = ["Pocion de vida", "Pocion de energia"]
#var moneda = preload("res://Inventario/Objetos/moneda/moneda.tscn").instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.active = true
	#definir objetibo del navegacion
	agent.set_target_location(target_position)
	randomize()
	gravity = 0# 2 * max_jump_heigth / pow(jump_duration, 2)
	max_jump_velocity = -jump_duration * gravity
	min_jump_velocity = -sqrt(2 * gravity * min_jump_heigth)
	jump_velocity = max_jump_velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		IDLE:
			animation.set("parameters/rc_blend/blend_amount", lerp(animation.get("parameters/rc_blend/blend_amount"), 0, delta * acceleration))
			movement_speed = 0
			persecution(delta)
			if $wander.time_left == 0:
				state = pick_random_state([IDLE, WANDER])
				$wander.start(rand_range(1,5))
		WANDER:

			animation.set("parameters/rc_blend/blend_amount", lerp(animation.get("parameters/rc_blend/blend_amount"), 1, delta * acceleration))
			persecution(delta)
			movement_speed = 5
			#new navigation
			if $movepath.is_stopped():
				$movepath.start()
				next = agent.get_next_location()
				direction = (next - global_transform.origin)
				#navigation
			if !firstmove:
				firstmove = true
			if thisplayer == null and global_transform.origin.distance_to(first_position) >= wander_range + 4:
				if $reset.is_stopped():
					$reset.start()
			elif $wander.time_left == 0 or global_transform.origin.distance_to(target_position) <= 3:
				state = pick_random_state([IDLE, WANDER])
				$wander.start(rand_range(2,5))  			
		CHASE:
			animation.set("parameters/rc_blend/blend_amount", lerp(animation.get("parameters/rc_blend/blend_amount"), 1, delta * acceleration))
			if thisplayer != null:
				movement_speed = 5
				if $movepath.is_stopped():
					$movepath.start()
					next = agent.get_next_location()
					direction = (next - global_transform.origin)
				if global_transform.origin.distance_to(thisplayer.global_transform.origin) <= 6:#4
					state = ATTACK

			else:
				movement_speed = 0
				state = IDLE

		ATTACK:
			movement_speed = 0
			
			if animation.get("parameters/ataque/active") == false and $attack_timer.is_stopped():
				animation.set("parameters/ataque/active", true)
				$attack_timer.start()
				state = CHASE
		DEAD:
			if mesh.visible:
				mesh.visible = false
				velocity = Vector3.ZERO
				
				var gusone = gusanofirst.instance()
				var gussec = gusanosecond.instance() 
#				gusone.global_transform = poso.global_transform
#				gussec.global_transform = poss.global_transform
				get_parent().add_child(gusone)
				get_parent().add_child(gussec)
				gusone.global_transform = self.global_transform
				#gusone.global_transform = 3
				gussec.global_transform = poss.global_transform
				#gussec.global_transform.origin = poss.global_transform.origin
				#gussec.global_rotation = poss.global_rotation
				#gussec.global_transform.scale = 3
				$dead.start()
				

	velocity = lerp(velocity , direction.normalized() * movement_speed, delta * friction * acceleration)
	velocity = move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	if firstmove:#$attack_timer.is_stopped():
		$cuerpobajo.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)

	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
#		if get_floor_normal().y != 1:
#			vertical_velocity = 0


func move_to(target_pos):
	agent.set_target_location(target_pos)
	
func persecution(_delta):
	if can_see_player():
		state = CHASE

func _on_persecution_body_entered(body):
	if body.is_in_group("players"):
		player = body
		thisplayer = player

func _on_persecution_body_exited(body):
	if thisplayer == body:
		player = null
		$seek.start()

func can_see_player():
	return player != null

func pick_random_state(list):
	list.shuffle()
	return list.pop_front()

func _on_wander_timeout():
	var target_vector = Vector3(rand_range(-wander_range, wander_range), 0, rand_range(-wander_range, wander_range))
	target_position = first_position + target_vector
	move_to(target_position)

func _on_move_timeout():
	if thisplayer != null:
		#navigation
		move_to(thisplayer.global_transform.origin)
	elif global_transform.origin.distance_to(first_position) >= wander_range + 6:
		move_to(first_position)

func _on_seek_timeout():
	if player == null:
		thisplayer = null


func _on_reset_timeout():
	
	#global_transform.origin = first_position
	pass # Replace with function body.


func _on_ataque_area_entered(area):
	if area.get_parent().is_in_group("players"):
		if thisplayer != null:
			thisplayer.receive_damage(ataque)

func enable_atk():
	ataque_area.monitoring = true
	ataque_col.disabled = false
	
func disable_atk():
	ataque_area.set_deferred("monitoring", false)
	ataque_col.set_deferred("disabled", true)


func _on_damage_area_entered(area):
	print("OK")
	if count < 2:#3
		count = count + 1
		animation.set("parameters/hit/active", true)
	else:
		state = DEAD



func _on_dead_timeout():
	damage_area.set_deferred("monitorable", false)
	damage_col.set_deferred("disabled", true)
	ataque_area.set_deferred("monitorable", false)
	ataque_col.set_deferred("disabled", true)
	persecution_area.set_deferred("monitorable", false)
	persecution_col.set_deferred("disabled", true)
	call_deferred("queue_free")
	pass # Replace with function body.
