extends Node2D


enum {UP, UPRIGHT, RIGHT, DOWNRIGHT, DOWN, DOWNLEFT, LEFT, UPLEFT}


@onready var map = get_parent()
@onready var suction_area: Area2D = $SuctionArea
@onready var kill_zone: Area2D = $KillZone
@onready var vsos_timer: Timer = $VsosTimer


@onready var inner_push_zones: Dictionary = {
	UP: $InnerPushZones/Up,
	UPRIGHT: $InnerPushZones/UpRight,
	RIGHT: $InnerPushZones/Right,
	DOWNRIGHT: $InnerPushZones/DownRight,
	DOWN: $InnerPushZones/Down,
	DOWNLEFT: $InnerPushZones/DownLeft,
	LEFT: $InnerPushZones/Left,
	UPLEFT: $InnerPushZones/UpLeft
}


func _on_suction_area_body_entered(body):
	if body.name == "Player":
		if body.is_crawling:
			await body.crawl_finished
		elif body.is_moving:
			await map.step_finished
	suck(body)
	activate()


func suck(body):
	if body.name == "Player":
		body.lock_controls(true, true, false)
		body.state_machine.change_state("Prone")
		body.stop_tweens()
	print("VSOS")
	var tween := create_tween()
	tween.tween_property(body, "position", self.position + map.position + Vector2(0, 0), 0.1)
	await tween.finished


func push_out(body):
	pass


func activate():
	vsos_timer.start()
	await vsos_timer.timeout
	for body in suction_area.get_overlapping_bodies():
		suck(body)
	vsos_timer.start()
	await vsos_timer.timeout
	for body in kill_zone.get_overlapping_bodies():
		print("LOPAEMSYA")
		body.LOPNUT()
