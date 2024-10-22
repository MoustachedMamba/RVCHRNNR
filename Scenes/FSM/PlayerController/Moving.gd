class_name Moving extends PCState


func _ready():
	await owner.ready


func enter(previous_state_path: String, data := {}) -> void:
	player.step_timer.timeout.connect(make_step)


func exit() -> void:
	player.step_timer.timeout.disconnect(make_step)


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("esc"):
		get_tree().quit()
	if _event.is_action_pressed("a"):
		player.strafe(player.DIRECTION.LEFT)
	if _event.is_action_pressed("d"):
		player.strafe(player.DIRECTION.RIGHT)


func make_step():
	player.map.make_step()
