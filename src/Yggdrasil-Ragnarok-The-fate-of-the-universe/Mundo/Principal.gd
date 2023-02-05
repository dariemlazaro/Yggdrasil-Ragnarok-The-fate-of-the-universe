extends Spatial
onready var player = get_node("Player")

onready var player_pos = get_node("Playerpos").get_children()
var count = 0
var started = false
func _ready():
	player.global_transform.origin = player_pos[Global.player_pos].global_transform.origin

func _process(_delta):
	if started == false and count == 3:
		started =true
		$Timer.start()


func _on_Timer_timeout():
	Global.goto_scene("res://Mundo/Escenas/Base_arbol/Base.tscn")
	pass
