class_name Prone extends PCState


func _ready() -> void:
	state_machine = get_parent()


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("c"):
		var tween := create_tween()
		tween.tween_property(player.progress_bar, "value", 100, 1)
		await tween.finished
		player.progress_bar.value = 0
		state_machine._transition_to_next_state(MOVING)


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(previous_state_path: String, data := {}) -> void:
	player.strafe_locked = true
	player.step_locked = true
	var tween := create_tween()
	tween.tween_property(player, "rotation", 90 * PI / 180, 0.1)


func exit() -> void:
	player.strafe_locked = false
	player.step_locked = false
	var tween := create_tween()
	tween.tween_property(player, "rotation", 0, 0.1)
