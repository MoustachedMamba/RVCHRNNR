class_name PCState extends State

const IDLE = "Idle"
const MOVING = "Moving"
const RUNNING = "Running"
const PRONE = "Prone"
const LOOKING = "Looking"


@onready var player: CharacterBody2D = owner


func _ready() -> void:
	super._ready()
	await owner.ready
	player = owner as CharacterBody2D
	assert(player != null, "The PlayerState state type must be used only in player scene.")
