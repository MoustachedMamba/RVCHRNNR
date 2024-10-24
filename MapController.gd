extends Node2D


signal step_finished


@export var player: CharacterBody2D
@export var STEP_SPEED := 15.0


var CHUNK_OFFSET := Vector2(-176, -288)
var CHUNK := preload("res://Scenes/Chunk.tscn")
var PREVIOUS_CHUNK: TileMapLayer
var CHUNK_COUNTER := 0


var CHUNK_LIST: Array[TileMapLayer] = []


@onready var area := $Area2D


func _ready():
	spawn_new_chunk()
	spawn_new_chunk()
	spawn_new_chunk()


func make_step():
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y + 32), 1 / STEP_SPEED)
	await tween.finished
	step_finished.emit()


func spawn_new_chunk():
	print("Spawned new chunk.")
	var new_chunk := CHUNK.instantiate()
	new_chunk.position.y = -288 * CHUNK_COUNTER
	new_chunk.position.x = -176
	self.add_child(new_chunk)
	CHUNK_LIST.append(new_chunk)
	CHUNK_COUNTER += 1
	if CHUNK_COUNTER > 3:
		var chunk_to_delete = CHUNK_LIST.pop_front()
		print("Deleteting chunk!")
		chunk_to_delete.queue_free()


func _on_area_2d_body_entered(body):
	if body == player:
		spawn_new_chunk()
		area.position.y -= 288
