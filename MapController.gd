extends Node2D


@export var STEP_SPEED := 15.0


var CHUNK_OFFSET := Vector2(-176, -288)
var CHUNK := preload("res://Scenes/Chunk.tscn")
var PREVIOUS_CHUNK: TileMapLayer
var CHUNK_COUNTER := 0


var CHUNK_LIST: Array[TileMapLayer] = []


@onready var ply = get_tree().get_nodes_in_group("Player")[0]
@onready var area := $Area2D
@onready var timer := $StepTimer
@onready var start_timer := $StartTimer

func _ready():
	spawn_new_chunk()
	spawn_new_chunk()
	spawn_new_chunk()
	timer.timeout.connect(make_step)
	timer.start(0.45)


func make_step():
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y + 32), 1 / STEP_SPEED)
	timer.start()


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
	if body == ply:
		spawn_new_chunk()
		area.position.y -= 288
