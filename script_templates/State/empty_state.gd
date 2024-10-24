extends State
# meta-name: Empty state
# meta-description: Very empty, very state
# meta-default: true
# meta-space-indent: 4

func _ready() -> void:
	super._ready()


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
