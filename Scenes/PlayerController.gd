extends CharacterBody2D


var deathscreen := preload("res://Scenes/DeathScreen.tscn").instantiate()
var new_bolt := preload("res://Scenes/Bolt.tscn")

@export var ANIM_SPEED := 50.0
@export var MOVE_SPEED := 50
@export var BOLT_SPEED := 4.0

@onready var RCLeft := $RayCastLeft
@onready var RCRight := $RayCastRight


@onready var dirs: Dictionary = {
	"left": $RayCastLeft,
	"right": $RayCastRight
}
@onready var inputs: Dictionary = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

var can_move: bool = true
var is_moving: bool = false
var can_strafe: bool = true
var is_stafing: bool = false

var is_knocked: bool = false


func _ready():
	self.add_to_group("Player")


func _unhandled_input(event):
	
	if event.is_action_pressed("esc"):
		get_tree().quit()
	
	if event.is_action_pressed("a"):
		strafe("left")
	if event.is_action_pressed("d"):
		strafe("right")
	if event.is_action_pressed("shift"):
		var run_tween := create_tween()
		run_tween.tween_property(self, "MOVE_SPEED", 100, 1)
	if event.is_action_released("shift"):
		var run_tween := create_tween()
		run_tween.tween_property(self, "MOVE_SPEED", 50, 1)
	if event.is_action_pressed("f"):
		throw_bolt(6)
	if event.is_action_pressed("c"):
		if is_knocked:
			stand_up()
		else:
			knock_down()


func strafe(dir):
	var current_raycast: RayCast2D = dirs[dir]
	current_raycast.force_raycast_update() 
	
	if !current_raycast.is_colliding() and !is_stafing:
		var tween = create_tween()
		is_stafing = true
		tween.tween_property(self, "position", position + inputs[dir] * 32, 1 / ANIM_SPEED)
		await tween.finished
		is_stafing = false


func knock_down():
	var rot_tween = create_tween()
	rot_tween.tween_property($Sprite2D, "rotation", 1.55, 0.2)
	await rot_tween.finished
	is_knocked = true
	self.can_move = false
	self.is_moving = false
	self.can_strafe = false


func stand_up():
	var rot_tween = create_tween()
	rot_tween.tween_property($Sprite2D, "rotation", 0, 0.2)
	await rot_tween.finished
	is_knocked = false
	self.can_move = true
	self.is_moving = true
	self.can_move = true


func gib():
	get_tree().root.add_child(deathscreen)
	self.queue_free()


func throw_bolt(force: int):
	var bolt := new_bolt.instantiate()
	var map := get_tree().get_nodes_in_group("Map")[0]
	map.add_child(bolt)
	bolt.position = self.position - map.position
	var tween := create_tween()
	var final_value = (Vector2(self.position.x, self.position.y - 32 * force) - map.position).snapped(Vector2(32, 32)) + Vector2(0, 16)
	tween.tween_property(bolt, "position", final_value, 1 / BOLT_SPEED)
