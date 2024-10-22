class_name Looking extends PCState


@export var looking_time: float = 1.3

func enter(previous_state_path: String, data := {}) -> void:
	var tween := create_tween()
	tween.tween_property(player.progress_bar, "value", 100, looking_time)
	await tween.finished

	player.progress_bar.value = 0
	await player.step_timer.timeout
	state_machine._transition_to_next_state(MOVING)

func exit() -> void:
	pass
