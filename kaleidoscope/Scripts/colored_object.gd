extends CanvasItem

@onready var VP : SubViewport = get_tree().root.get_child(0).get_node("SubViewport")
@onready var test_sprite : Sprite2D = get_tree().root.get_child(0).get_node("Sprite2D")

@export() var color : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# apply shader and set shader parameters
	material = ShaderMaterial.new()
	material.shader = load("res://Scripts/hidden_object.gdshader")
	material.set_shader_parameter("light_color", Vector3(color.r, color.g, color.b))
	
	#var m : ViewportTexture = ViewportTexture.new()
	#m.viewport_path = VP.get_path()
	material.set_shader_parameter("mask", VP.get_texture())
	
	print("fuuuck")
	test_sprite.texture = material.get_shader_parameter("mask")
	test_sprite.material.set_shader_parameter("mask", material.get_shader_parameter("mask"))
