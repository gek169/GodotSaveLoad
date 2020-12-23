extends Control

# This script demonstrates how to alter StyleBoxes at runtime.
# Custom theme item properties aren't considered Object properties per se.
# This means that you should use `add_stylebox_override("normal", ...)`
# instead of `set("custom_styles/normal", ...)`.
var bBro = false
onready var label = $VBoxContainer/Label
onready var button = $VBoxContainer/Button
onready var button2 = $VBoxContainer/Button2
onready var reset_all_button = $VBoxContainer/ResetAllButton
onready var spatial = $Spatial
onready var cam = $Spatial/Camera
onready var SphereScene: PackedScene
onready var SphereClones = $Spatial/SphereClones
func dupe_sphereboi():
	pass
	var dupe: RigidBody = SphereScene.instance()
	dupe.global_transform = $Spatial/SphereSpawn.global_transform
	$Spatial/SphereClones.add_child(dupe,false)
func _ready():
	# Focus the first button automatically for keyboard/controller-friendly navigation.
	button.grab_focus()
	#spatial.remove_child(SphereBoi)
	#massive hack! terrible! Bad!
	#spatial.remove_child(SphereClones)
	#dupe_the_damn_sphereclones()
	SphereScene = preload("res://Sphere.tscn")
func _physics_process(_delta):
	if(bBro):
		dupe_sphereboi()
func _on_button_pressed():
	# We have to modify the normal, hover and pressed styleboxes all at once
	# to get a correct appearance when the button is hovered or pressed.
	# We can't use a single StyleBox for all of them as these have different
	# background colors.
	var new_stylebox_normal = button.get_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(1, 1, 0)
	var new_stylebox_hover = button.get_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(1, 1, 0)
	var new_stylebox_pressed = button.get_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(1, 1, 0)
	button.add_stylebox_override("normal", new_stylebox_normal)
	button.add_stylebox_override("hover", new_stylebox_hover)
	button.add_stylebox_override("pressed", new_stylebox_pressed)
	button.text="Pressed!"
	label.add_color_override("font_color", Color(1, 1, 0.5))
	#button.hide()
	bBro = !bBro
	$Spatial/TGF.play(0)
func _on_button2_pressed():
	var new_stylebox_normal = button2.get_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(0, 1, 0.5)
	var new_stylebox_hover = button2.get_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(0, 1, 0.5)
	var new_stylebox_pressed = button2.get_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(0, 1, 0.5)

	button2.add_stylebox_override("normal", new_stylebox_normal)
	button2.add_stylebox_override("hover", new_stylebox_hover)
	button2.add_stylebox_override("pressed", new_stylebox_pressed)
	
	label.add_color_override("font_color", Color(0.5, 1, 0.75))
	spatial.remove_child(cam)

func _on_reset_all_button_pressed():
	# Resetting a theme override is done by setting the property to:
	# - `null` for fonts, icons, styleboxes, and shaders.
	# - `0` for constants.
	# - Colors must be reset manually by adding the previous color value as an override.
	button.add_stylebox_override("normal", null)
	button.add_stylebox_override("hover", null)
	button.add_stylebox_override("pressed", null)
	button.text="Bruh!!!!"
	button.show()
	button2.add_stylebox_override("normal", null)
	button2.add_stylebox_override("hover", null)
	button2.add_stylebox_override("pressed", null)
	if not (has_node("Spatial/Camera")):
		spatial.add_child(cam)
	# If you don't have any references to the previous color value,
	# you can instance a node at runtime to get this value.
	var default_label_color = Label.new().get_color("font_color")
	label.add_color_override("font_color", default_label_color)
	for node in $Spatial/SphereClones.get_children():
		node.queue_free()


func on_quit_pressed():
	print("Quitting...")
	get_tree().quit()


func _on_ButtonSave_pressed():
	Saver.save_game("save1")


func _on_ButtonLoad_pressed():
	Saver.load_game("save1")
