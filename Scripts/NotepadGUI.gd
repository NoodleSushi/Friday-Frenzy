extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
var is_play = false
var is_done = false
func _ready() -> void:
	update_notepad()
	Global.connect("list_updated", self, "update_notepad")
	Global.connect("finished", self, "finished")

func update_notepad() -> void:
	var text = ""
	for i in Global.list:
		text += "- " + i+"\n"
	$Game/TextureRect/Label.text = text
	$Tween.interpolate_property($Game/TextureRect, "rect_position", Vector2(0, -32), Vector2.ZERO, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	$PageFlip.play()
	
func _process(delta: float) -> void:
	if !is_play && Input.is_action_just_pressed("ui_accept"):
		is_play = true
		$Menu/AnimationPlayer.play("StartGame")
	var second = fmod(Global.countdown,60.0)
	var minute = int(Global.countdown)/60
	
	$Game/Countdown.text = "%02d : %02.2f" % [minute, second]

	if is_done && $Timer.is_stopped() && Input.is_action_just_pressed("ui_accept"):
		Global.reset()
		get_tree().reload_current_scene()

func activate() -> void:
	Global.in_game = true

func finished() -> void:
	$Timer.start()
	$Congrats.visible = true
	var second = fmod(Global.countdown,60.0)
	var minute = int(Global.countdown)/60
	$Congrats/Title2.text = "HEY YOU MADE IT!\nYou finished in\n"+("%02d : %02.2f" % [minute, second]+"\npress A/SPACE to restart")
	is_done = true
	
