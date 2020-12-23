class_name SerializeableTransform

#This class exists purely to save and load transforms.
#the format for serializing transforms is name.property.subproperty in the dict.
#This is a helper which can be used by your classes in saving and loading state.
#var name: String
var transform: Transform
#pass in the dictionary to tack this serializeable transform to
func Save(name: String, datadict: Dictionary):
	datadict[name + ".basis.x.x"] = transform.basis.x.x
	datadict[name + ".basis.x.y"] = transform.basis.x.y
	datadict[name + ".basis.x.z"] = transform.basis.x.z
	
	datadict[name + ".basis.y.x"] = transform.basis.y.x
	datadict[name + ".basis.y.y"] = transform.basis.y.y
	datadict[name + ".basis.y.z"] = transform.basis.y.z
	
	datadict[name + ".basis.z.x"] = transform.basis.z.x
	datadict[name + ".basis.z.y"] = transform.basis.z.y
	datadict[name + ".basis.z.z"] = transform.basis.z.z
	datadict[name + ".origin.x"] = transform.origin.x
	datadict[name + ".origin.y"] = transform.origin.y
	datadict[name + ".origin.z"] = transform.origin.z
	return datadict
#pass 
func Load(name: String, datadict: Dictionary):
	transform.basis.x.x = datadict[name + ".basis.x.x"]
	transform.basis.x.y = datadict[name + ".basis.x.y"]
	transform.basis.x.z = datadict[name + ".basis.x.z"]
	transform.basis.y.x = datadict[name + ".basis.y.x"]
	transform.basis.y.y = datadict[name + ".basis.y.y"]
	transform.basis.y.z = datadict[name + ".basis.y.z"]
	transform.basis.z.x = datadict[name + ".basis.z.x"]
	transform.basis.z.y = datadict[name + ".basis.z.y"]
	transform.basis.z.z = datadict[name + ".basis.z.z"]
	transform.origin.x = datadict[name + ".origin.x"]
	transform.origin.y = datadict[name + ".origin.y"]
	transform.origin.z = datadict[name + ".origin.z"]
	return transform
