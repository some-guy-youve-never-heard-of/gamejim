extends PointLight2D

@onready var player : Node = get_tree().root.get_child(0).get_node("Player")
@onready var area : Area2D = get_node("Area2D")

const LIT_THRESHOLD : float = 128

@export var spotlight_id : int = 0

func _ready() -> void:
	get_node("Area2D/CollisionShape2D").shape.radius = (256.0 / 2) * texture_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	visible = (player.selected_light == spotlight_id)
	global_position = get_global_mouse_position()
	
	var bodies = area.get_overlapping_bodies()
	for b in bodies:
		if b is ColoredObject:
			b.lit = (b.color == color)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is ColoredObject:
		body.lit = false
