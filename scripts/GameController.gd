extends Node

const Player := preload("res://scripts/Player.gd")
const PlayerScene := preload("res://entities/Player.tscn")
var _player1 : Player = PlayerScene.instance()
#var _player2 : Player = PlayerScene.instance()

var stage = 1
var _timer := Timer.new()
var starting_room = "res://rooms/Test.tscn"

func _ready():
	get_tree().get_current_scene().add_child(_player1)
	#get_tree().get_current_scene().add_child(_player2)
	_player1.position = Vector2(400, 200)
	#_player2.position = Vector2(600, 200)
	_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(_timer) #to process
	_timer.start(5*60)

func _on_timer_timeout():
	_timer.stop()
	_player1.switch_stage()
	change_room(_player1.player2_scene)
	stage = 2

func change_room(door):
	var path = door.exit_room_path
	var next_packed_scene : PackedScene = load(path)
	var next_scene : Node = next_packed_scene.instance()
	
	_player1.get_parent().remove_child(_player1)
	get_tree().current_scene.queue_free()
	get_tree().get_root().add_child(next_scene)
	get_tree().current_scene = next_scene
	get_tree().current_scene.add_child(_player1)
	
	var exit_position = get_tree().current_scene.find_node(door.exit_door_name).global_position
	_player1.position = exit_position


func game_over():
	print("game over")
