extends Area

signal player_teleported

export var destination_path : NodePath setget set_destination_path

var Destination : Spatial

func set_destination_path(val : NodePath):
	destination_path = val
	Destination = get_node(destination_path)

func _ready() -> void:
	set_destination_path(destination_path)
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_teleported")
		body.global_transform.origin = Destination.global_transform.origin
