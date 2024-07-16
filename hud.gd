extends CanvasLayer
var score
var c_score
var left_time
var ranked_name

@export var ranking_name : Control
@export var ranking_score : Control

var huds = ["Menu", "InGame", "EndScore", "Ranking", "Credits"]

signal start
signal stop
# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	c_score = 0
	left_time = 30
	ranked_name = ""
	$Menu/Mole/AnimatedSprite2D.play("default")
	$Menu/Mole/AnimatedSprite2D2.play("default")
	play_sound("今日も始めましょう！")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_score(p):
	score = max(0, score + p)
	$InGame/VBoxContainer/ScoreLabel.text = str(score) + " score"
	

func _on_limit_timer_timeout():
	left_time -= 1
	$InGame/VBoxContainer/TimeLabel.text = str(left_time) + " seconds left"
	if left_time == 10:
		play_sound("Countdown")
	if left_time <= 0:
		$"Sounds/なかよしクッキング".stop()
		stop_game()

func stop_game():
	$InGame/LimitTimer.stop()
	stop.emit()
	setup_end_score()
	$"Sounds/今日も始めましょう！".play()
	
func play_sound(sound_name: String):
	if sound_name == "Punch":
		sound_name += str(randi() % 2 + 1)
	$Sounds.get_node(sound_name).play()

func change_hud(hud_name: String):
	for i in huds:
		if(i == hud_name):
			get_node(i).show()
		else:
			get_node(i).hide()


func _on_back_button_pressed():
	play_sound("PushButton")
	change_hud("Menu")


func _on_start_button_pressed():
	play_sound("PushButton")
	$"Sounds/今日も始めましょう！".stop()
	change_hud("InGame")
	score = 0
	left_time = 30
	$InGame/VBoxContainer/TimeLabel.text = str(left_time) + " seconds left"
	$InGame/LimitTimer.start()
	start.emit()

func setup_end_score():
	$EndScore/VBoxContainer/ScoreLabel.text = "Score: " + str(score)
	$EndScore/VBoxContainer/Label.text = "confirming Leader Board..."
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	c_score = score
	if c_score != 0 and ( len(sw_result["scores"]) < 10 or sw_result["scores"][9]["score"] < c_score ):
		$EndScore/VBoxContainer/Label.text = "Ranked In!"
		$EndScore/VBoxContainer/LineEdit.show()
		$EndScore/VBoxContainer/UploadButton.show()
		$EndScore/VBoxContainer/LineEdit.text = ranked_name
		
	else:
		$EndScore/VBoxContainer/Label.text = "Ranked out ;("
		$EndScore/VBoxContainer/LineEdit.hide()
		$EndScore/VBoxContainer/UploadButton.hide()


func _on_upload_button_pressed():
	play_sound("PushButton")
	ranked_name = $EndScore/VBoxContainer/LineEdit.text
	if ranked_name != "" :
		$EndScore/VBoxContainer/LineEdit.hide()
		$EndScore/VBoxContainer/UploadButton.hide()
		SilentWolf.Scores.save_score(ranked_name, c_score)
	else:
		$EndScore/VBoxContainer/Label.text = "you should enter your name"


func _on_ranking_button_pressed():
	play_sound("PushButton")
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	change_hud("Ranking")
	var length = len(sw_result["scores"])
	for rank in length:
		var rn = sw_result["scores"][rank]["player_name"]
		var rs = sw_result["scores"][rank]["score"]
		ranking_name.get_node(str(rank+1)).text = str(rn)
		ranking_score.get_node(str(rank+1)).text = str(rs)


func _on_credit_button_pressed():
	play_sound("PushButton")
	change_hud("Credits")



func _on_exit_button_pressed():
	get_tree().quit()
