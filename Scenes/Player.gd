extends CharacterBody2D


enum DIRECTION {LEFT, RIGHT}

@export var map: Node2D
@export var speed: float = 10.0

@onready var step_timer: Timer = $StepTimer
@onready var left_raycast: RayCast2D = $LeftRayCast
@onready var right_raycast: RayCast2D = $RightRayCast
@onready var forward_raycast: RayCast2D = $ForwardRayCast
@onready var music: AudioStreamPlayer2D = $Music
@onready var progress_bar: TextureProgressBar = $ProgressBar

@onready var leftup_raycast: RayCast2D = $LeftUpRayCast
@onready var rightup_raycast: RayCast2D = $RightUpRayCast


var strafe_locked: bool = false
var step_locked: bool = false

var is_moving: bool = false
var is_strafing: bool = false

func _ready():
	pass


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
	if is_strafing and (leftup_raycast.is_colliding() or rightup_raycast.is_colliding()):
		return
	is_moving = true
	map.make_step()
	await map.step_finished
	is_moving = false
