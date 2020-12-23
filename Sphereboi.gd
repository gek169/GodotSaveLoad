extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Save():
	var datadict: Dictionary = {
		"filename": filename,
		"parent": get_parent().get_path(),
	}
	var MainTransformSaver: SerializeableTransform = SerializeableTransform.new()
	MainTransformSaver.transform = global_transform
	datadict = MainTransformSaver.Save("global_transform",datadict)
	#MainTransformSaver.free()
	return datadict
	
func Load(var datadict: Dictionary):
	var MainTransformSaver: SerializeableTransform = SerializeableTransform.new()
	global_transform = MainTransformSaver.Load("global_transform",datadict)

