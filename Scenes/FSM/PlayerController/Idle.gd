class_name Idle extends PCState


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("w"):
		state_machine._transition_to_next_state(MOVING)


func exit():
	player.step_timer.start()
	player.music.play()
	player.map.make_step()
