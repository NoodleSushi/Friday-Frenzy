extends Spatial


enum TELEPORTER {
	CLOTHING,
	MARKET,
	IT,
	ARCADE
}

var mesh_lookup = [
	[
		preload("res://VoxAssets/Clothing/BlueShirt.vox"),
		preload("res://VoxAssets/Clothing/Dress.vox"),
		preload("res://VoxAssets/Clothing/StripedShirt.vox"),
	],
	[
		preload("res://VoxAssets/Market/StorageApples.vox"),
		preload("res://VoxAssets/Market/StorageOranges.vox"),
		preload("res://VoxAssets/Market/StorageWatermelon.vox"),
	],
	[
		preload("res://VoxAssets/IT/StorageConsole.vox"),
		preload("res://VoxAssets/IT/StorageFlatScreenTV.vox"),
		preload("res://VoxAssets/IT/StorageMonitor.vox"),
	],
	[
		Mesh.new(),
		Mesh.new(),
		Mesh.new(),
	]
]

const NAME_LOOKUP = [
	[
		"Blue Shirt",
		"Dress",
		"Striped Shirt"
	],
	[
		"Apple",
		"Orange",
		"Watermelon"
	],
	[
		"Game Console",
		"Flat Screen TV",
		"Monitor"
	]
]
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_Teleporter_player_teleported(id: int) -> void:
	$StoreBaseMesh.material_override.albedo_color = [
		Color("ffccaa"),
		Color("f3ef7d"),
		Color("d1b9ff"),
		Color("543d58")
	][id]
	$TeleporterLobby.destination_path = $ExitPositions.get_children()[id].get_path()
	for citizen in $Entities.get_children():
		(citizen as CharacterController).set_material(Global.get_random_skin())
	var isle_idx = 0
	for isle in $Storages.get_children():
		isle.set_mesh(mesh_lookup[id][isle_idx])
		isle.returned_name = NAME_LOOKUP[id][isle_idx]
		isle_idx += 1
	visible = true

func _on_TeleporterLobby_player_teleported() -> void:
	visible = false
