extends Node2D

@export var bush_scene: PackedScene
@export var bushes_up: Node2D
@export var bushes_middle: Node2D
@export var bushes_down: Node2D

var bushes = ["Up", "Middle", "Down"]

var bushes_up_name = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
var bushes_middle_name = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
var bushes_down_name = ["z", "x", "c", "v", "b", "n", "m"]
var bushes_name = [bushes_up_name, bushes_middle_name, bushes_down_name]

signal change_input_limit(t:bool)
signal sounds_play(sound_name:String)
signal hud_change(hud_name:String)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_bushes()
	$HUD.start.connect(start_game)
	$HUD.stop.connect(stop_game)
	sounds_play.connect($HUD.play_sound)
	hud_change.connect($HUD.change_hud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func generate_bushes():
	var window_width = get_window().size[0] #windowの横の長さ
	var window_height = get_window().size[1] #windowの縦の長さ
	var bitween_bushes = window_width / 16 #ブッシュ間の長さ
	
	var bushes_size = window_width / 16 #ブッシュのサイズ
	
	var second_bushes_shift = bushes_size * 0.2 #1段目に対する2段目のブッシュのずれの長さ
	
	var third_bushes_shift = bushes_size * 0.5 #2段目に対する3段目のブッシュのずれの長さ
	
	
	
	bushes_up.position = Vector2(0,(window_height / 12) * 4.5)
	bushes_middle.position = Vector2(0,(window_height / 12) * 7)
	bushes_down.position = Vector2(0,(window_height / 12) * 9.5)
	
	var current_position = 0
	for name in bushes_up_name:
		var bush = bush_scene.instantiate()
		current_position += bitween_bushes + bushes_size / 2
		bush.position = Vector2(current_position, 0.0)
		bush.set_key_action_name(name)
		bush.change_score.connect($HUD.change_score)
		change_input_limit.connect(bush.change_input_limit)
		bush.music_play.connect($HUD.play_sound)
		bushes_up.add_child(bush)
	current_position = bushes_size * 0.25
	for name in bushes_middle_name:
		var bush = bush_scene.instantiate()
		current_position += bitween_bushes + bushes_size / 2 
		bush.position = Vector2(current_position, 0.0)
		bush.set_key_action_name(name)
		bush.change_score.connect($HUD.change_score)
		change_input_limit.connect(bush.change_input_limit)
		bush.music_play.connect($HUD.play_sound)
		bushes_middle.add_child(bush)
	current_position = bushes_size * 0.95
	for name in bushes_down_name:
		var bush = bush_scene.instantiate()
		current_position += bitween_bushes + bushes_size / 2 
		bush.position = Vector2(current_position, 0.0)
		bush.set_key_action_name(name)
		bush.change_score.connect($HUD.change_score)
		change_input_limit.connect(bush.change_input_limit)
		bush.music_play.connect($HUD.play_sound)
		bushes_down.add_child(bush)



func _on_start_timer_timeout():
	$MoleTimer.start()
	sounds_play.emit("なかよしクッキング")
	change_input_limit.emit(false)
	
func get_two_random():
	var r1 = randi() % 3
	var r2 = 0
	if r1 == 0:
		r2 = randi() % 10
	elif r1 == 1:
		r2 = randi() % 9
	else:
		r2 = randi() % 7
	return [r1, r2]

func _on_mole_timer_timeout():
	var r = get_two_random()
	var node = get_node("Bushes/"+bushes[r[0]]+"/"+bushes_name[r[0]][r[1]])
	if !node.is_busy():
		node.pushup_mole()

func start_game():
	$StartTimer.start()
	sounds_play.emit("Start")
func stop_game():
	$MoleTimer.stop()
	hud_change.emit("EndScore")
	change_input_limit.emit(true)
