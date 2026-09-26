extends Node2D
class_name ColoredObject

@onready var VP : SubViewport = get_tree().root.get_child(0).get_node("SubViewport")
@onready var test_sprite : Sprite2D = get_tree().root.get_child(0).get_node("Sprite2D")

@export var color : Color
@export var canvas : CanvasItem = self

var lit : bool = false
var c : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	c = get_node("CollisionShape2D")
	
	# apply shader and set shader parameters
	canvas.material = ShaderMaterial.new()
	canvas.material.shader = load("res://Scripts/hidden_object.gdshader")
	canvas.material.set_shader_parameter("light_color", Vector3(color.r, color.g, color.b))
	
	#var m : ViewportTexture = ViewportTexture.new()
	#m.viewport_path = VP.get_path()
	canvas.material.set_shader_parameter("mask", VP.get_texture())
	
	#print("fuuuck")
	#test_sprite.texture = material.get_shader_parameter("mask")
	#test_sprite.material.set_shader_parameter("mask", material.get_shader_parameter("mask"))

func _physics_process(delta: float) -> void:
	if c:
		c.disabled = !lit
		if lit: print("hooray")
