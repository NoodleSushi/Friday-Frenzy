extends KinematicBody
class_name CharacterController

const GRAVITY = Vector3.DOWN * 100
var direction := 0.0
var velocity := Vector3()
var speed := 0.0
var impulse := Vector3()

func set_material(new_material: Material) -> void:
	$MeshInstance.set_surface_material(0, new_material)

func process_movement(delta: float) -> void:
	rotation.y = lerp_angle(rotation.y, direction, delta*5)
	
	var hvel = velocity
	hvel.y = 0
	hvel = hvel.linear_interpolate(transform.basis.z * 20 * speed * (1.0 if is_on_floor() else 0.5), delta * (10.0 if speed > 0 else 5.0))
	
	velocity = Vector3(hvel.x, velocity.y, hvel.z)
	velocity += GRAVITY * delta
	# global_translate(Vector3(_dir.x, 0, _dir.y) * delta * 20)
	if impulse.length() > 0:
		velocity = impulse
		impulse = Vector3.ZERO
	
	velocity = move_and_slide(velocity, Vector3.UP)
