extends Spatial
onready var player = get_node("Player")

onready var player_pos = get_node("Playerpos").get_children()

func _ready():
	player.global_transform.origin = player_pos[Global.player_pos].global_transform.origin

