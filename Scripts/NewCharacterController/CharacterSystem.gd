extends Node

const GRAVITY = Vector3.DOWN * 100

enum STATE {
	ROAM,
	PAUSE,
}

func set_material(ch: CharacterEntity, new_material: Material) -> void:
	ch.get_node("MeshInstance").set_surface_material(0, new_material)

func process_movement(ch: CharacterEntity, delta: float) -> void:
	ch.rotation.y = lerp_angle(ch.rotation.y, ch.direction, delta*5)
	
	var hvel = ch.velocity
	hvel.y = 0
	hvel = hvel.linear_interpolate(ch.transform.basis.z * 20 * ch.speed * (1.0 if ch.is_on_floor() else 0.5), delta * (10.0 if ch.speed > 0 else 5.0))
	
	ch.velocity = Vector3(hvel.x, ch.velocity.y, hvel.z)
	ch.velocity += GRAVITY * delta
	# global_translate(Vector3(_dir.x, 0, _dir.y) * delta * 20)
	if ch.impulse.length() > 0:
		ch.velocity = ch.impulse
		ch.impulse = Vector3.ZERO
	
	ch.velocity = ch.move_and_slide(ch.velocity, Vector3.UP)
