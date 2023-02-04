extends Node2D
#controles de tiempo

#transisiones
var loader
var wait_frames
var time_max = 100 # msec
var current_scene 
var animated_progress=0
var new_value=0
var loading=false
# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.get_node("Loading/Fondo").hide()
	pass # Replace with function body.
	
func goto_scene(path): # game requests to switch to this scene
	if not $Tween.is_active():
		$Tween.interpolate_callback(self,0.1, "loading_data", path)
		$Tween.start()

func loading_data(path):
	animated_progress=0
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	#Global.get_node("Loading/progress").value = 0

	loader = ResourceLoader.load_interactive(path)	

	if loader == null: # check for errors
		print("error") #show_error()
		return
	loading=true

	current_scene.queue_free() # get rid of the old scene

	# start your "loading..." animation
	Global.get_node("Loading/Control2/Node2D/Loading").visible = true
	Global.get_node("Loading/Control2/Node2D/Loading").playing = true

	Global.get_node("Loading/Control/MarginContainer/CenterContainer/progress").show()
	Global.get_node("Loading/Control/Fondo").show()
	wait_frames = 5
	set_process(true)

func _process(_time):
	Global.get_node("Loading/Control/MarginContainer/CenterContainer/progress").value = animated_progress
	if loading:
		if loader == null:
			# no need to process anymore
			return

		if wait_frames > 0: # wait for frames to let the "loading" animation show up
			wait_frames -= 1
			return

		var t = OS.get_ticks_msec()
		while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

			# poll your loader
			var err =  loader.poll()

			if err == ERR_FILE_EOF: # Finished loading.
				var resource = loader.get_resource()
				loader = null
				set_new_scene(resource)
				break
			elif err == OK:
				update_progress()
			else: # error during loading
				print("error") #show_error()
				loader = null
				break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
	new_value=progress * 100
	$Tween.interpolate_property(self, "animated_progress", animated_progress, new_value, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()

	# ... or update a progress animation?
	#var length = get_node("animation").get_current_animation_length()

	# Call this on a paused animation. Use "true" as the second argument to force the animation to update.
	#get_node("animation").seek(progress * length, true)

func set_new_scene(scene_resource):
	new_value=100
	$Tween.interpolate_property(self, "animated_progress", animated_progress, new_value, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()
	#current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	
	Global.get_node("Timer").start()
	#old_scene.queue_free()

func _on_Timer_timeout():
	loading=false
	Global.get_node("Loading/Control/Fondo").hide()
	Global.get_node("Loading/Control/MarginContainer/CenterContainer/progress").hide()
	Global.get_node("Loading/Control2/Node2D/Loading").hide()
	Global.get_node("Loading/Control2/Node2D/Loading").playing = false
	#set_process(false)
	pass # Replace with function body.

#func _input(_event):
#	if Input.is_action_just_pressed("load"):
#		load_game()
#	if Input.is_action_just_pressed("save"):
#		save_game()
		
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables
func save_game():
	set_process_input(false)
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistente")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()
	set_process_input(true)
	print("saved")

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	set_process_input(false)
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persistente")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()
	set_process_input(true)
	print("loaded")



#Player persistent info
var player_dinero = 100

var player_pos = 0
var noche = false
var dia = true

