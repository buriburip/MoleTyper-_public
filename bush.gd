extends Node2D
var key_action_name
var busy = false
var input_limit = false
signal change_score(score)

signal music_play(music_name:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mole/AnimatedSprite2D.play("none")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !input_limit and Input.is_action_pressed(key_action_name):
		if busy:
			music_play.emit("Punch")
			$Mole/AnimatedSprite2D.stop()
			busy = false
			$Mole/AnimatedSprite2D.play("death")
			print("nice")
			change_score.emit(100)
			input_limit = true
			input_limiter()
		else:
			music_play.emit("Dodge")
			change_score.emit(-25)
			input_limiter()

func input_limiter():
	input_limit = true
	$InputLimitTimer.start()

func set_key_action_name(n):
	name = n
	key_action_name = "input_" + n
	$Label.text = n

func is_busy():
	return busy

func pushup_mole():
	busy = true
	$MoleTimer.start()
	#$Mole/AnimatedSprite2D.visible = true
	$Mole/AnimatedSprite2D.play("up")


func _on_mole_timer_timeout():
	if busy:
		$Mole/AnimatedSprite2D.play("down")

func _on_animated_sprite_2d_animation_finished():
	if busy and $Mole/AnimatedSprite2D.animation == "down":
		busy = false
	if $Mole/AnimatedSprite2D.animation == "death":
		$Mole/AnimatedSprite2D.play("none")


func _on_input_limit_timer_timeout():
	input_limit = false

func change_input_limit(t : bool):
	input_limit = t

func play_sound(sound_name: String):
	pass
