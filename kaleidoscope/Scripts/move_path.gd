extends Node

@export var enabled : bool = false

#@export_enum("Direct", "Circular") var move_type : String = "Direct"

@export var time_per_point : float = 1.0
@export var cyclic : bool = true
@export var stop_at_index : int = -1

@export_category("Direct Movement Settings")
@export var points : Array[Vector2] = [Vector2(0,0), Vector2(1,0)]

#@export_category("Circular Movement Settings")
#@export var radius : float = 300
#@export var curve_direction : int = -1

@onready var parent : Node2D = get_parent()

var start_point : Vector2
var current_wishpoint : Vector2
var index : int = 1
var time : float = 0
var deltax : float = 0

func _ready() -> void:
	start_point = parent.global_position
	current_wishpoint = start_point + points[index]
	deltax = ((current_wishpoint-parent.global_position)/time_per_point).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !enabled:
		return
	
	time += delta
	if parent.global_position == current_wishpoint || time >= time_per_point:
		parent.global_position = current_wishpoint
		time = 0
		
		index += 1
		if index == points.size(): 
			index = 0
			if !cyclic: enabled = false; return
		if index == stop_at_index: enabled = false; return
		
		current_wishpoint = start_point + points[index]
	
	parent.global_position += (parent.global_position - current_wishpoint).normalized() * deltax
	
	#match move_type:
		#"Direct":
			#
		#"Circular":
			#pass
	#

func activate() -> void:
	enabled = !enabled
