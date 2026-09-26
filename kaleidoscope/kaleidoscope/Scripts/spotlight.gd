extends PointLight2D

@onready var player : Node = get_tree().root.get_child(0).get_node("Player")
@onready var area : Area2D = get_node("Area2D")

const LIT_THRESHOLD : float = 128

@export var spotlight_id : int = 0

func _ready() -> void:
	get_node("Area2D/CollisionShape2D").shape.radius = (256.0 / 2) * texture_scale
	area.set_collision_mask_value(3, true)
var previously_lit_bodies: Array = []

func _physics_process(delta: float) -> void:
	var is_active = (player.selected_light == spotlight_id) and enabled
	visible = is_active
	
	var currently_lit: Array = []
	
	if is_active:
		var bodies = area.get_overlapping_bodies()
		for b in bodies:
			if b is ColoredObject:
				if color.r >= b.color.r and color.g >= b.color.g and color.b >= b.color.b:
					b.lit = true
					currently_lit.append(b)
					
	for b in previously_lit_bodies:
		if is_instance_valid(b) and not currently_lit.has(b):
			b.lit = false
			
	previously_lit_bodies = currently_lit

func _on_area_2d_body_exited(body: Node2D) -> void:
	pass
