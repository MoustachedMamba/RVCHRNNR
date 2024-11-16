extends CharacterBody2D


enum DIRECTION {LEFT, RIGHT}
enum {LEFT, RIGHT, LEFTUP, RIGHTUP, UP}

@export var map: Node2D
@export var speed: float = 25.0

@onready var sprite = $Sprite2D

@onready var run_timer = $RunTimer
@onready var step_timer: Timer = $StepTimer

@onready var left_raycast: RayCast2D = $Ray/LeftRayCast
@onready var right_raycast: RayCast2D = $Ray/RightRayCast
@onready var forward_raycast: RayCast2D = $Ray/ForwardRayCast
@onready var leftup_raycast: RayCast2D = $Ray/LeftUpRayCast
@onready var rightup_raycast: RayCast2D = $Ray/RightUpRayCast
@onready var ray: Dictionary = {
	LEFT: left_raycast,
	RIGHT: right_raycast,
	LEFTUP: leftup_raycast,
	RIGHTUP: rightup_raycast,
	UP: forward_raycast
}

@onready var left_area = $Areas/Left
@onready var right_area = $Areas/Right
@onready var up_area = $Areas/Up
@onready var left_up_area = $Areas/LeftUp
@onready var right_up_area = $Areas/RightUp
@onready var area: Dictionary = {
	LEFT: left_area,
	RIGHT: right_area,
	UP: up_area,
	LEFTUP: left_up_area,
	RIGHTUP: right_up_area
}

@onready var music: AudioStreamPlayer2D = $Music
@onready var progress_bar: TextureProgressBar = $ProgressBar


var strafe_locked: bool = false
var step_locked: bool = false

var is_moving: bool = false
var is_strafing: bool = false


func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()


func strafe(dir: DIRECTION):
	var new_pos: float
	
	left_raycast.force_raycast_update()
	right_raycast.force_raycast_update()

	leftup_raycast.force_raycast_update()
	rightup_raycast.force_raycast_update()

	if dir == DIRECTION.LEFT:
		if left_raycast.is_colliding() or strafe_locked:
			return
		if is_moving and leftup_raycast.is_colliding():
			return
		new_pos = self.position.x - 32
	elif dir == DIRECTION.RIGHT:
		if right_raycast.is_colliding() or strafe_locked:
			return
		if is_moving and rightup_raycast.is_colliding():
			return
		new_pos = self.position.x + 32
	is_strafing = true
	var tween := create_tween()
	tween.tween_property(self, "position:x", new_pos, 1 / speed)
	strafe_locked = true
	await tween.finished
	is_strafing = false
	strafe_locked = false


func make_step():
	forward_raycast.force_raycast_update()
	if step_locked or forward_raycast.is_colliding():
		return
	if is_strafing and (leftup_raycast.is_colliding() and not left_raycast.is_colliding()):
		return
	if is_strafing and (rightup_raycast.is_colliding() and not rightup_raycast.is_colliding()):
		return
	is_moving = true
	map.make_step()
	await map.step_finished
	is_moving = false


func crawl(dir) -> void:
	var pos_delta: Dictionary = {
		LEFT: Vector2(-32, 0),
		UP: Vector2(0, -32),
		RIGHT: Vector2(32, 0),
		LEFTUP: Vector2(-32, -32),
		RIGHTUP: Vector2(32, -32)
	}
	var tween := create_tween()
	tween.tween_property(progress_bar, "value", 100, 1)
	await tween.finished
	force_move(self.position + pos_delta[dir], 10)
	progress_bar.value = 0


func force_move(pos: Vector2, speed: float) -> void:
	var tween := create_tween()
	is_moving = true
	_lock_controls()
	tween.tween_property(self, "position", pos, 1 / speed)
	await tween.finished
	_unlock_controls()
	is_moving = false


func _lock_controls() -> void:
	step_locked = true
	strafe_locked = true


func _unlock_controls() -> void:
	step_locked = false
	strafe_locked = false
