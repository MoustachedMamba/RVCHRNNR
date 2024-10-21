extends Node2D


@onready var music := $Player/Music


func _ready():
	music.play()
