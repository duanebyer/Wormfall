extends Node

var _timer := Timer.new()
var starting_room = "res://rooms/Test.tscn"
var switch = false
var stage = 1

func _ready():
	_timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(_timer) #to process
	_timer.start(5*60)
	
func _on_timer_timeout():
	_timer.stop()
	switch = true
	stage = 2
	
func game_over():
	print("game over")
