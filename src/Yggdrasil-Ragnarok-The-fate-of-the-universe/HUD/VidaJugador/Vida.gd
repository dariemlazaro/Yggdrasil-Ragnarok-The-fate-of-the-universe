extends HBoxContainer

onready var vida = $fondobarra/centrar/vida
var vidaint=100
var animated_color=1
var new_value_color=1
onready var animated_vida = vida.value
var new_value_vida=99999

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var porciento= (new_value_vida * 100)/vida.max_value
	
	vida.tint_progress=Color(1,animated_color,1,1)
	if porciento<=80:
		new_value_color=(vida.value/vida.max_value)
		$Tween.interpolate_property(self, "animated_color", animated_color, new_value_color, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not $Tween.is_active():
			$Tween.start()
	else:
		new_value_color=1
		$Tween.interpolate_property(self, "animated_color", animated_color, new_value_color, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not $Tween.is_active():
			$Tween.start()
		
			
	vida.value=animated_vida
	vidaint=int(vida.value)

	#new_value_vida=vida.value-20
	$Tween.interpolate_property(self, "animated_vida", animated_vida, new_value_vida, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()
