extends CharacterBody2D


enum DIRECTION {LEFT, RIGHT}

@export var map: Node2D
@export var speed: float = 10.0

@onready var step_timer: Timer = $StepTimer
@onready var left_raycast: RayCast2D = $LeftRayCast
@onready var right_raycast: RayCast2D = $RightRayCast
@onready var beat_notifier: RhythmNotifier = $RhythmNotifier

var strafe_locked: bool = false

func _ready():
	step_timer.start()


func make_step():
	map.make_step()
	step_timer.start()


func strafe(dir: DIRECTION):
	var new_pos: float
	left_raycast.force_raycast_update()
	right_raycast.force_raycast_update()
	if dir == DIRECTION.LEFT:
		if left_raycast.is_colliding() or strafe_locked:
			return
		new_pos = self.position.x - 32
	elif dir == DIRECTION.RIGHT:
		if right_raycast.is_colliding() or strafe_locked:
			return
		new_pos = self.position.x + 32
	var tween := create_tween()
	tween.tween_property(self, "position:x", new_pos, 1 / speed)
	strafe_locked = true
	await tween.finished
	strafe_locked = false
