extends CharacterController


func _ready() -> void:
	$CameraRig/Camera.Player = self
	rotation.y = PI
	direction = rotation.y

func _physics_process(delta: float) -> void:
	if !Global.in_game:
		return
	var _x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var _y := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var _dir := Vector2(_x, _y).normalized()
	if _dir.length() > 0:
		direction = -_dir.angle()-PI*0.5
	speed = _dir.length()
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = 25
	process_movement(delta)
