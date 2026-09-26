extends Node2D

@onready var player = get_parent()
@onready var light_parent : Node = get_tree().root.get_child(0).get_node("Lights (Lights MUST be children of this node)")

const RADIUS : float = 20
const SEPARATION : float = 20

var lights : Dictionary = {}

func _ready() -> void:
	var light_list = light_parent.get_children()
	player.light_number = light_list.size()
	
	for l in light_list:
		lights.merge({l.spotlight_id : l.color})
	
	for l in lights.keys():
		var circle = MeshInstance2D.new()
		add_child(circle)
		
		circle.mesh = SphereMesh.new()
		circle.mesh.radius = RADIUS
		circle.mesh.height = 2*RADIUS
		
		var g = Gradient.new()
		g.set_color(0,lights[l])
		g.set_color(1,lights[l])
		circle.texture = GradientTexture1D.new()
		circle.texture.gradient = g
		
		var x = (l - player.selected_light)*(2*RADIUS + SEPARATION)
		circle.position = Vector2(x,-(100 + SEPARATION))
		
		lights.merge({l : circle}, true)

func _process(delta: float) -> void:
	visible = player.selector_open
	
	for l in lights.keys():
		lights[l].position.x = lerpf(lights[l].position.x, (l - player.selected_light)*(2*RADIUS + SEPARATION), 0.02)
