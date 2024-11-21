class_name Prone extends PCState


@onready var dic: Dictionary = {
	player.LEFT: _left_crawl,
	player.RIGHT: _right_crawl,
	player.UP: _up_crawl,
	player.UPRIGHT: _rightup_crawl,
	player.UPLEFT: _leftup_crawl,
	player.DOWNRIGHT: _rightdown_crawl,
	player.DOWNLEFT: _leftdown_crawl,
	player.DOWN: _down_crawl
}


func _ready() -> void:
	state_machine = get_parent()


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("c"):
		player.stand()
		await player.stand_finished
		state_machine._transition_to_next_state(MOVING)


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(previous_state_path: String, data := {}) -> void:
	for key in dic.keys():
		player.area[key].input_event.connect(dic[key])
	player.fall()


func exit() -> void:
	for key in dic.keys():
		player.area[key].input_event.disconnect(dic[key])


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
		player.crawl(player.UPLEFT)


func _rightup_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.UPRIGHT)


func _down_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.DOWN)


func _leftdown_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.DOWNLEFT)


func _rightdown_crawl(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if _event.is_action_pressed("leftclick") and not player.is_moving:
		player.crawl(player.DOWNRIGHT)
