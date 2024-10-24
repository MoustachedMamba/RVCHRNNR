class_name Moving extends PCState


func enter(previous_state_path: String, data := {}) -> void:
	player.step_timer.timeout.connect(player.make_step)


func exit() -> void:
	player.step_timer.timeout.disconnect(player.make_step)


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("esc"):
		get_tree().quit()
	if _event.is_action_pressed("a"):
		player.strafe(player.DIRECTION.LEFT)
	if _event.is_action_pressed("d"):
		player.strafe(player.DIRECTION.RIGHT)
	if _event.is_action_pressed("s"):
		player.strafe_locked = true
		player.step_locked = true
		await player.step_timer.timeout
		player.strafe_locked = false
		player.step_locked = false
		state_machine._transition_to_next_state(LOOKING)
