extends Spatial
onready var player = get_node("Player")

onready var player_pos = get_node("Playerpos").get_children()

func _ready():
	player.global_transform.origin = player_pos[Global.player_pos].global_transform.origin
#	$AnimationPlayer.play("cambiaranoche")
#	$WorldEnvironment/AnimationPlayer.play("cambiaranoche")
#	$CanvasLayer/AnimationPlayer.play("INICIO")

	
func dia():
	Global.dia = true
	Global.noche = false 
	
func noche():
	Global.noche = true
	Global.dia = false 
