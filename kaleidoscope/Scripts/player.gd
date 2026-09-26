extends CharacterBody2D

@export var SPEED : float = 400.0
@export var JUMP_VELOCITY : float = -1000.0
@export var COYOTE_AMOUNT : float = 0.2
@export var ACCELERATE_WEIGHT : float = 0.2
@export var STOP_WEIGHT : float = 0.125
@export var JUMP_STOP_WEIGHT : float = 0.2

@export var GRAVITY : float = 1960.0
@export var falling_gravity_mult : float = 2

const COLOR_WHEEL_TIMESCALE : float = 0.2
const TIMESCALE_WEIGHT : float = 0.1

var previously_grounded : bool = true
var coyote_time : float = 0.0
var effective_gravity
var selected_light = 0
var light_number = 0

var selector_open : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		reset_level()
	
	if Input.is_action_pressed("light_selector"):
		Engine.time_scale = lerpf(Engine.time_scale, COLOR_WHEEL_TIMESCALE, TIMESCALE_WEIGHT)
		selector_open = true
	else:
		Engine.time_scale = lerpf(Engine.time_scale, 1.0, TIMESCALE_WEIGHT)
		selector_open = false

func _physics_process(delta: float) -> void:
	# increase gravity if falling
	if velocity.y > 0:
		effective_gravity = GRAVITY * falling_gravity_mult
	else:
		effective_gravity = GRAVITY
	
	# add gravity
	if !is_on_floor():
		velocity += get_gravity().normalized() * effective_gravity * delta
		coyote_time = clampf(coyote_time - delta,0,COYOTE_AMOUNT)
	else:
		coyote_time = COYOTE_AMOUNT
	
	if selector_open:
		if Input.is_action_just_pressed("left"):
			selected_light -= 1
		elif Input.is_action_just_pressed("right"):
			selected_light += 1
		
		selected_light = clamp(selected_light, 0, light_number - 1)
		
		previously_grounded = is_on_floor()
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") && (is_on_floor() || coyote_time > 0):
		velocity.y = JUMP_VELOCITY
		coyote_time = 0
	
	if !Input.is_action_pressed("jump") && !is_on_floor() && velocity.y < 0:
		velocity.y = snapped(lerpf(velocity.y, 0, JUMP_STOP_WEIGHT), .001)
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		if sign(velocity.x) == sign(direction) or 0:
			velocity.x = snapped(lerpf(velocity.x, SPEED * direction, ACCELERATE_WEIGHT), .001)
		else:
			velocity.x = snapped(lerpf(0, SPEED * direction, ACCELERATE_WEIGHT), .001)
	else:
		# transition from current velocity to zero and round the velocity (otherwise will approach but never reach zero)
		velocity.x = snapped(lerpf(velocity.x, 0, STOP_WEIGHT), .001)
	
	previously_grounded = is_on_floor()
	
	move_and_slide()

func reset_level() -> void:
	get_tree().reload_current_scene()
