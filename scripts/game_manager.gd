extends Node2D

signal keydown(key)
signal keypress(key)

const UNIT_SIZE = 16
const MAX_X = 6
const MAX_Y = 24
func _process(delta):
	_process_input()


func _process_input():
	if Input.is_action_just_pressed("ui_right"):
		emit_signal('keydown', 'right')
	elif Input.is_action_just_pressed("ui_left"):
		emit_signal('keydown', 'left')
	elif Input.is_action_just_pressed("ui_down"):
		emit_signal('keydown', 'rotate')
	elif Input.is_action_pressed("ui_space"):
		emit_signal('keypress', 'speed')

