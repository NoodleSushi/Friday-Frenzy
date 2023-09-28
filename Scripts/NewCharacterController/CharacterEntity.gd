extends Node
class_name CharacterEntity

var direction := 0.0
var velocity := Vector3()
var speed := 0.0
var impulse := Vector3()

var random_dir := -1
var given_speed := 0.5
var state := randi()%2
var rand_turn := -1
