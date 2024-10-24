class_name Running extends PCState


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_released("shift"):
		state_machine._transition_to_next_state(MOVING)
	if _event.is_action_pressed("c"):
		state_machine._transition_to_next_state(PRONE)


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(previous_state_path: String, data := {}) -> void:
	player.strafe_locked = true
	player.run_timer.timeout.connect(player.make_step)


func exit() -> void:
	player.strafe_locked = false
	player.run_timer.timeout.disconnect(player.make_step)
