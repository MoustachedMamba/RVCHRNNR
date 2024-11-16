class_name Prone extends PCState


@onready var dic: Dictionary = {
	player.LEFT: _left_crawl,
	player.RIGHT: _right_crawl,
	player.UP: _up_crawl,
	player.RIGHTUP: _rightup_crawl,
	player.LEFTUP: _leftup_crawl
}


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
	for key in dic.keys():
		player.area[key].input_event.connect(dic[key])

	player.strafe_locked = true
	player.step_locked = true
	var tween := create_tween()
	tween.tween_property(player.sprite, "rotation", 90 * PI / 180, 0.1)
	await tween.finished


func exit() -> void:
	for key in dic.keys():
		player.area[key].input_event.disconnect(dic[key])
	
	player.strafe_locked = false
	player.step_locked = false
	var tween := create_tween()
	tween.tween_property(player.sprite, "rotation", 0, 0.1)
	await tween.finished
	


func _left_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.LEFT)


func _right_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.RIGHT)


func _up_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.UP)


func _leftup_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.LEFTUP)


func _rightup_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.RIGHTUP)
