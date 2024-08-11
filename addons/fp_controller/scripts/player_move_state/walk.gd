class_name Walk extends PlayerState

var input_dir: Vector2
var move_speed: float


func enter(_msg := {}) -> void:
	pass


func handle_input(event: InputEvent) -> void:
	if Input.is_action_pressed("sprint"):
		state_machine.transition_to(state_machine.movement_state[state_machine.SPRINT])
	
	if event.is_action_pressed("jump") && player.is_on_floor():
		state_machine.transition_to(
			state_machine.movement_state[state_machine.JUMP], 
			{ 
				"player_velocity" : player.velocity, 
				state_machine.TO : state_machine.WALK,
			}
		)


func physics_update(_delta: float) -> void:
	input_dir = player.input_direction
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("move_back"):
		move_speed = player.walk_back_speed
	else:
		move_speed = player.walk_speed
	
	if direction:
		player.velocity.x = direction.x * move_speed
		player.velocity.z = direction.z * move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, move_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, move_speed)
		
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
	
	if player.velocity.y < 0:
		state_machine.transition_to(
			state_machine.movement_state[state_machine.FALL],
			{ state_machine.TO : state_machine.WALK }
		)
