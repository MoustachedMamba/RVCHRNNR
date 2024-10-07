extends Node2D


@onready var map = self.get_parent()
@onready var activation_area := $ActivationArea


var dir = ["Up", "UpRight", "Right", "DownRight", "Down", "DownLeft", "Left", "UpLeft"]
var inner_pushers := Dictionary()


func _ready():
	for d in dir:
		inner_pushers[d] = $InnerPusher.get_node(d)
