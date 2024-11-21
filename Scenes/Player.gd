extends CharacterBody2D

signal step_finished
signal crawl_finished
signal stand_finished
signal force_move_finished


enum DIRECTION {LEFT, RIGHT}
enum {UP, UPRIGHT, RIGHT, DOWNRIGHT, DOWN, DOWNLEFT, LEFT, UPLEFT}

@export var map: Node2D
@export var speed: float = 25.0

@onready var sprite: Sprite2D = $Sprite2D

@onready var run_timer: Timer = $RunTimer
@onready var step_timer: Timer = $StepTimer

# Это пиздец
@onready var left_raycast: RayCast2D = $Ray/LeftRayCast
@onready var right_raycast: RayCast2D = $Ray/RightRayCast
@onready var forward_raycast: RayCast2D = $Ray/ForwardRayCast
@onready var leftup_raycast: RayCast2D = $Ray/LeftUpRayCast
@onready var rightup_raycast: RayCast2D = $Ray/RightUpRayCast
@onready var down_raycast: RayCast2D = $Ray/DownRayCast
@onready var rightdown_raycast: RayCast2D = $Ray/RightDownRayCast
@onready var leftdown_raycast: RayCast2D = $Ray/LeftDownRayCast


@onready var ray: Dictionary = {
	LEFT: left_raycast,
	RIGHT: right_raycast,
	UPLEFT: leftup_raycast,
	UPRIGHT: rightup_raycast,
	UP: forward_raycast,
	DOWNLEFT: leftdown_raycast,
	DOWNRIGHT: rightdown_raycast,
	DOWN: down_raycast
}

# Это тоже
@onready var left_area = $Areas/Left
@onready var right_area = $Areas/Right
@onready var up_area = $Areas/Up
@onready var left_up_area = $Areas/LeftUp
@onready var right_up_area = $Areas/RightUp
@onready var rightdown_area = $Areas/RightDown
@onready var down_area = $Areas/Down
@onready var leftdown_area = $Areas/LeftDown



@onready var area: Dictionary = {
	LEFT: left_area,
	RIGHT: right_area,
	UP: up_area,
	UPLEFT: left_up_area,
	UPRIGHT: right_up_area,
	DOWNLEFT: leftdown_area,
	DOWNRIGHT: rightdown_area,
	DOWN: down_area
}

@onready var music: AudioStreamPlayer2D = $Music
@onready var death_sound: AudioStreamPlayer = $Death
@onready var progress_bar: TextureProgressBar = $ProgressBar



@onready var state_machine: StateMachine = $StateMachine


var strafe_locked: bool = false
var step_locked: bool = false
var crawl_locked: bool = false

var is_moving: bool = false
var is_strafing: bool = false
var is_crawling: bool = false

# TWEENS
@onready var strafe_tween: Tween
@onready var crawl_tween: Tween
@onready var fall_tween: Tween
@onready var stand_tween: Tween


# Interface
@onready var deathscreen := preload("res://Scenes/DeathScreen.tscn")


func _unhandled_input(event) -> void:
	if event.is_action_pressed("esc"):
		get_tree().quit()
	if event.is_action_pressed("stop"):
		stop_tweens()


func strafe(dir: DIRECTION) -> void:
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
	strafe_tween = create_tween()
	strafe_tween.tween_property(self, "position:x", new_pos, 1 / speed)
	strafe_locked = true
	await strafe_tween.finished
	is_strafing = false
	strafe_locked = false


func make_step() -> void:
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
	step_finished.emit()


func crawl(dir) -> void:
	if crawl_locked:
		return
	lock_controls(true, true, true)
	var pos_delta: Dictionary = {
		LEFT: Vector2(-32, 0),
		UP: Vector2(0, -32),
		RIGHT: Vector2(32, 0),
		UPLEFT: Vector2(-32, -32),
		UPRIGHT: Vector2(32, -32),
		DOWN: Vector2(0, 32),
		DOWNRIGHT: Vector2(32, 32),
		DOWNLEFT: Vector2(-32, 32)
	}
	for k in ray.keys():
		ray[k].force_raycast_update()
	if ray[dir].is_colliding():
		return
	is_crawling = true
	crawl_tween = create_tween()
	crawl_tween.tween_property(progress_bar, "value", 100, 1)
	await crawl_tween.finished
	
	var tween = create_tween()
	is_moving = true
	lock_controls()
	tween.tween_property(self, "position", position + pos_delta[dir], 0.1)
	await tween.finished
	unlock_controls()
	is_moving = false
	progress_bar.value = 0
	is_crawling = false
	crawl_finished.emit()


func stop_crawl():
	if crawl_tween:
		if crawl_tween.is_running():
			crawl_tween.kill()
			progress_bar.value = 0


func fall() -> void:
	lock_controls(true, true, false)
	var fall_tween = create_tween()
	fall_tween.tween_property(sprite, "rotation", 90 * PI / 180, 0.1)
	await fall_tween.finished


func stand() -> void:
	stand_tween = create_tween()
	stand_tween.tween_property(progress_bar, "value", 100, 1)
	await stand_tween.finished
	progress_bar.value = 0
	lock_controls(false, false, true)
	var tween = create_tween()
	tween.tween_property(sprite, "rotation", 0, 0.1)
	await tween.finished
	stand_finished.emit()


func stop_stand() -> void:
	if stand_tween:
		if stand_tween.is_running():
			stand_tween.kill()
			progress_bar.value = 0


func force_move(pos: Vector2, move_speed: float) -> void:
	var tween = create_tween()
	is_moving = true
	lock_controls()
	tween.tween_property(self, "position", pos, 1 / move_speed)
	await tween.finished
	unlock_controls()
	is_moving = false


func lock_controls(lc_step: bool = true, lc_strafe: bool = true, lc_crawl: bool = true) -> void:
	step_locked = lc_step
	strafe_locked = lc_strafe
	crawl_locked = lc_crawl


func unlock_controls(step: bool = true, strafe: bool = true, crawl: bool = true) -> void:
	step_locked = !step
	strafe_locked = !strafe
	crawl_locked = !crawl


func stop_tweens():
	stop_crawl()
	stop_stand()


func LOPNUT():
	var ds := deathscreen.instantiate()
	music.stop()
	death_sound.play()
	self.add_child(ds)
