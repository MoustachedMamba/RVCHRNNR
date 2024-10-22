class_name State extends Node


signal finished(next_state_path: String, data: Dictionary)


var state_machine: StateMachine


func _ready() -> void:
	state_machine = get_parent()


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(previous_state_path: String, data := {}) -> void:
	pass


func exit() -> void:
	pass
