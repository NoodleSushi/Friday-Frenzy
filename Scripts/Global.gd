extends Node


const MATERIAL_ORIGINAL = preload("res://Entities/MaterialCharacter.material")

var skins := []

var names = [
		"Blue Shirt",
		"Dress",
		"Striped Shirt",
		"Apple",
		"Orange",
		"Watermelon",
		"Game Console",
		"Flat Screen TV",
		"Monitor"
]

var in_game = false
var countdown = 0
var list = []

signal list_updated
signal finished

func _ready() -> void:
	randomize()
	#generate skins
	for i in range(6):
		var new_material : SpatialMaterial = MATERIAL_ORIGINAL.duplicate()
		new_material.set_texture(0, load("res://Textures/citizen" + str(i) + ".png"))
		skins.append(new_material)
	reset()

func reset() -> void:
	list = []
	for _i in range(8):
		list.append(names[randi()%names.size()])
	emit_signal("list_updated")
	countdown = 0

func get_random_skin() -> Material:
	return skins[randi() % skins.size()]

func submit_item(item : String):
	for i in range(list.size()):
		if item == list[i]:
			list.remove(i)
			emit_signal("list_updated")
			break
	if list.size() == 0:
		in_game = false
		emit_signal("finished")

func _process(delta: float) -> void:
	if !in_game:
		return
	countdown += delta
