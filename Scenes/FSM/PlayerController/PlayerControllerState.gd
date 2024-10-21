class_name PCState extends State


const WALKING = "Moving"
const RUNNING = "Running"
const PRONE = "Prone"
const LOOKING = "Looking"


@onready var player: CharacterBody2D = owner


func _ready() -> void:
	await owner.ready
	player = owner as CharacterBody2D
	assert(player != null, "The PlayerState state type must be used only in player scene.")
