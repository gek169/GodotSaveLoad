#This file provides a class which can save and load a save file.
#It is meant to be a singleton (Project Settings->Autoload)

#All objects you wish to be saved/loaded must comply with the following:
#1) Must be its own scene
#2) Must have its root node in that scene be in the "Saved" group.
#3) Must implement Save (returning json-able dictionary)
#4) Must implement Load (taking in dictionary loaded from json)

#If you wish to extend the save system to save objects which
#do not comply with these criteria, for instance,
#because you cannot split them out into a separate scene,
#or because you do not want them to be deleted, you will have to
#modify this program.

#Copyright © 2020 David Webster
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

extends Node

var waitTime: int = 1
var countdown: int = 0
var save_filename: String = ""
#var Background: Thread
func _ready():
	set_process(false)
	print("Saver working...")
func save_game(var savename: String):
	var save_metadata = File.new()
	var save_game = File.new()
	save_game.open("user://" + savename + ".save", File.WRITE)
	save_metadata.open("user://" + savename + ".meta", File.WRITE)
	save_metadata.store_line(get_tree().current_scene.filename)
	save_metadata.store_line("user://" + savename + ".save")
	save_metadata.close()
	var save_nodes = get_tree().get_nodes_in_group("Saved")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("Save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("Save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game(var savename: String):
	set_process(true)
	var save_meta = File.new()
	if not save_meta.file_exists("user://" + savename + ".meta"):
		return
	save_meta.open("user://" + savename + ".meta", File.READ)
	var scene_filename = save_meta.get_line()
	save_filename = save_meta.get_line()
	save_meta.close()
	get_tree().change_scene(scene_filename)
	countdown = waitTime

func _process(_delta):
	if !(save_filename == "") and countdown > 0:
		countdown = countdown - 1
	if countdown == 0 and !(save_filename == ""):
		inner_load_game()



func inner_load_game():
	#print("Loading")
	set_process(false)
	var save_game = File.new()
	
	
	
	
	if not save_game.file_exists(save_filename):
		print("Unable to open save file:" + save_filename)
		return # Error! We don't have a save to load.
	
	var save_nodes = get_tree().get_nodes_in_group("Saved")
	for i in save_nodes:
		i.queue_free()
	
	#print("Still running!")
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(save_filename, File.READ)
	#print("Opened:" + save_filename + "!!!")
	while save_game.get_position() < save_game.get_len():
		#print("Loading Line")
	# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

        # Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		if(new_object.has_method("Load")):
			new_object.Load(node_data)
	save_game.close()
	save_filename = ""
