extends RoomManager


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rooms_convert()
	var player = get_parent().get_node("Player/camroot/h/v/pivot/Camera")
	preview_camera = get_path_to(player)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
