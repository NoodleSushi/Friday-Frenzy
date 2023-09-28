extends Spatial

export var returned_name := ""

var player_is_entered = false
var timer = 0
var meshes = []
var original_positions = []

func set_mesh(new_mesh : Mesh) -> void:
	for child in get_children():
		if child is MeshInstance:
			child.mesh = new_mesh
			meshes.append(child)
			original_positions.append(child.transform.origin)

func _on_Area_body_entered(body: Node):
	if body.is_in_group("Player"):
		player_is_entered = true

func _on_Area_body_exited(body: Node):
	if body.is_in_group("Player"):
		player_is_entered = false

func _process(delta: float) -> void:
	if player_is_entered:
		var idx = 0
		for mesh in meshes:
			var new_pos = original_positions[idx] + Vector3(0, sin(idx*0.5 + timer*8)*0.5, 0)
			mesh.transform.origin = mesh.transform.origin.linear_interpolate(new_pos, delta*4)
			idx += 1
		timer = fmod(timer + delta, TAU)
		if Input.is_action_just_pressed("recieve"):
			Global.submit_item(returned_name)
	else:
		var idx = 0
		for mesh in meshes:
			mesh.transform.origin = mesh.transform.origin.linear_interpolate(original_positions[idx], delta*2)
			idx += 1
