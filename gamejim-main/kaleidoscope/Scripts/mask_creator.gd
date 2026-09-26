extends Node

@onready var light_parent : Node = get_tree().root.get_child(0).get_node("Lights (Lights MUST be children of this node)")

#var modulate : CanvasModulate
var real_lights : Array[Node]
var copy_lights : Array[Node]

func _ready() -> void:
	real_lights = light_parent.get_children()
	for l in real_lights:
		var i : int = real_lights.find(l)
		copy_lights.append(PointLight2D.new())
		add_child(copy_lights[i])
		copy_lights[i].texture = real_lights[i].texture
		copy_lights[i].transform = real_lights[i].transform
		copy_lights[i].color = real_lights[i].color
		copy_lights[i].energy = real_lights[i].energy
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for l in real_lights:
		var i : int = real_lights.find(l)
		copy_lights[i].transform = real_lights[i].transform
		copy_lights[i].enabled = real_lights[i].enabled and real_lights[i].visible
