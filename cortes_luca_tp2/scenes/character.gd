extends CharacterBody2D

@onready
var anim = $AnimatedSprite2D

const SPEED = 300.0

enum state {
	IDLE,
	RUNNING,
	TELEPORTING,
	DYING,
}

var current_state = state.IDLE
var gravity_flipped = false

func _physics_process(delta: float) -> void:
	# Idle conditions
	if is_on_floor() and velocity.x == 0 or is_on_ceiling() and velocity.x == 0:
		current_state = state.IDLE
	# Running conditions
	if is_on_floor() and not velocity.x == 0 or is_on_ceiling() and not velocity.x == 0:
		current_state = state.RUNNING
	# Teleporting conditions
	if not is_on_floor() and not is_on_ceiling():
		current_state = state.TELEPORTING
		
	# Animations and transitions
	if current_state == state.IDLE:
		anim.play("idle")
	if current_state == state.RUNNING:
		anim.play("running")
	if current_state == state.TELEPORTING:
		anim.play("grav_change")
		anim.stop()
		
	# Gravity flip input
	if Input.is_action_just_pressed("teleport"):
		velocity += get_gravity() * -1
		gravity_flipped = !gravity_flipped
		
	# Gravity change
	var gravity_multiplier = -1.0 if gravity_flipped else 1.0
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * 1

	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
