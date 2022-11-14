extends Node2D

signal keydown

const UNIT_SIZE = 32
const MAX_X = 7
const MAX_Y = 7
var Block = preload("res://prefabs//Block.tscn")
var blocks = []
var running_block_group = null
var running_group = RunningBlockGroup.new(self, Block)

func _process(delta):
	_process_input()


func _process_input():
	if Input.is_action_just_pressed("ui_right"):
		emit_signal('keydown', 'right')
	elif Input.is_action_just_pressed("ui_left"):
		emit_signal('keydown', 'left')
	elif Input.is_action_just_pressed("ui_down"):
		emit_signal('keydown', 'rotate')

 
func check(x, y):
	if x < 0 || x > MAX_X || y < 0 || y > MAX_Y:
		return true

	for block in blocks:
		if block.step_x == x and block.step_y == y:
			return block
	return null


func append_blocks(_blocks):
	blocks.append_array(_blocks)

func append_block(block):
	blocks.append(block)
