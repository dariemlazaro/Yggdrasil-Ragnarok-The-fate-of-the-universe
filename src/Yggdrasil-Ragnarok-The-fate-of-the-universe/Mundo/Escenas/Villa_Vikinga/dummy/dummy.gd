extends MeshInstance

var count = 0;

func _ready():
	pass # Replace with function body.

func _on_Area_area_entered(_area):
	print("OK")
	if count < 1:#3
		count = count + 1
	else:
		$Area/CollisionShape.disabled = true
		get_parent().get_parent().get_parent().get_parent().get_parent().count+=1
		$dead.start()


func _on_dead_timeout():
	call_deferred("queue_free")









#func _on_Area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
#	$Area/CollisionShape.disabled = true
#	print("OK")
#	if count < 1:#3
#		count = count + 1
#	else:
#		$dead.start()
#	pass # Replace with function body.


