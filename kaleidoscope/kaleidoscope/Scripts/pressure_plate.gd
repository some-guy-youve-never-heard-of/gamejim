extends Area2D
class_name PressurePlate

@export var target: Node
@export var color: Color = Color(0, 0, 0, 1) # Default black
@export var target_light: PointLight2D
@export var target_position_node: Node2D
@export var start_position_node: Node2D 
@export var latch: bool = false
@export var move_duration: float = 1.5

var pressed_count: int = 0
@onready var sprite = get_node_or_null("Sprite2D")
var initial_sprite_y: float = 0.0
var has_moved: bool = false
var tween: Tween

func _ready() -> void:
	if sprite:
		initial_sprite_y = sprite.position.y
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_target()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D or body is RigidBody2D:
		pressed_count += 1
		_update_target()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D or body is RigidBody2D:
		pressed_count -= 1
		_update_target()

func _move_light_to(destination: Vector2) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(target_light, "global_position", destination, move_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _update_target() -> void:
	var is_pressed = pressed_count > 0
	
	if sprite:
		sprite.position.y = initial_sprite_y + (5.0 if is_pressed else 0.0)
	
	if target and "enabled" in target:
		target.enabled = is_pressed
		
	if color == Color(0, 0, 0, 1): # black
		if target_light and target_position_node:
			if is_pressed:
				_move_light_to(target_position_node.global_position)
				has_moved = true
			elif has_moved and not latch and start_position_node:
				_move_light_to(start_position_node.global_position)
				has_moved = false
	else: # color
		for node in get_tree().get_nodes_in_group("colored_objects"):
			if node is ColoredObject:
				if color.r >= node.color.r and color.g >= node.color.g and color.b >= node.color.b:
					node.plate_lit = is_pressed
