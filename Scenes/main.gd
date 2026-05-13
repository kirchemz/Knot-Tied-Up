extends Node2D

@onready var rope = preload("res://Scenes/rope_segment.tscn")

var player_1
var player_2

var rope_instance
var rope_width = 16
var rope_created = false

func _process(delta: float) -> void:
	if player_1 and player_2:
		if not rope_created:
			rope_instance = rope.instantiate()
			add_child(rope_instance)
			rope_created = true
		rope_instance.position.x = (player_1.position.x + player_2.position.x)/2
		rope_instance.position.y = (player_1.position.y + player_2.position.y)/2
		rope_instance.look_at(player_1.position)
		var player_distance = player_1.position.distance_to(player_2.position)
		rope_instance.scale.x = player_distance / rope_width
