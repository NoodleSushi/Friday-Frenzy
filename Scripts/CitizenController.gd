extends CharacterController

enum STATE {
	ROAM,
	PAUSE,
}

var random_dir := -1
var given_speed := 0.5
var state := randi()%2
var rand_turn := -1


var TimerSpeed := Timer.new()
var TimerState := Timer.new()
var TimerRotate := Timer.new()
var TimerJump := Timer.new()

func _ready() -> void:
	randomize()
	add_child(TimerSpeed)
	TimerSpeed.one_shot = true
	TimerSpeed.connect("timeout", self, "_on_TimerSpeed_timeout")
	_on_TimerSpeed_timeout()

	add_child(TimerState)
	TimerState.one_shot = true
	direction = rand_range(0, TAU)

	add_child(TimerRotate)
	TimerRotate.one_shot = true

	add_child(TimerJump)
	TimerJump.one_shot = true
	set_material(Global.get_random_skin())


func _process(delta: float) -> void:
	# if !$VisibilityEnabler.is_on_screen():
	# 	return
	match state:
		STATE.ROAM:
			if TimerJump.is_stopped():
				TimerJump.start(rand_range(0, 1))
				if is_on_floor() && rand_range(0, 10) < 1:
					velocity.y = 25
			if TimerState.is_stopped():
				TimerState.start(rand_range(1, 3))
				if rand_range(0, 10) < 1:
					state = STATE.PAUSE
					continue
			speed = given_speed
			if $RayCasts/RayCast1.is_colliding() && $RayCasts/RayCast3.is_colliding() || $RayCasts/RayCast2.is_colliding():
				speed = -given_speed
				direction += 5*delta * random_dir
			else:
				random_dir = [-1, 1][randi()%2]
				if $RayCasts/RayCast1.is_colliding():
					direction -= 5*delta
				elif $RayCasts/RayCast3.is_colliding():
					direction += 5*delta
				elif TimerRotate.is_stopped():
					var _chance = rand_range(0, 10)
					if _chance < 3:
						rand_turn = [-1, 1][randi()%2]
						TimerRotate.start(rand_range(0.1, 0.5))
					else:
						rand_turn = 0
						TimerRotate.start(rand_range(1, 2))
				elif rand_turn != 0:
					direction += 5*delta*rand_turn

		STATE.PAUSE:
			speed = 0
			if TimerState.is_stopped():
				TimerState.start(rand_range(0.5, 1.5))
				var _chance = rand_range(0, 10)
				if _chance < 9:
					state = STATE.ROAM
					continue
				if _chance > 8:
					direction += [-1, 1][randi()%2] * PI * 0.25
	# if is_on_floor() && $RayCasts/RayCast4.is_colliding():
	# 	velocity.y = 25
	# 	var collider = $RayCasts/RayCast4.get_collider()
	# 	if collider.is_in_group("Player"):
	# 		collider.impulse = Vector3(0, 25, -50)
	# 		impulse = Vector3(0, 100, 0)
	process_movement(delta)

func _on_TimerSpeed_timeout():
	TimerSpeed.start(rand_range(0.25, 2))
	given_speed = rand_range(0.25, 1.5)
