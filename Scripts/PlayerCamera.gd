extends Camera

var Player : KinematicBody setget set_player
var diff : Vector3
func _ready() -> void:
	set_as_toplevel(true)

# func set_player(new_player: KinematicBody) -> void:
# 	Player = new_player
# 	update()

func set_player(val : KinematicBody) -> void:
	Player = val
	if Player:
		diff = transform.origin - Player.transform.origin

func _physics_process(_delta: float) -> void:
	if !Player:
		return
	transform.origin = Player.transform.origin + diff
	look_at(Player.transform.origin, Vector3.UP)