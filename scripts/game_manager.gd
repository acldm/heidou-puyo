extends Node2D

signal move(go_dir)

const UNIT_SIZE = 32
const MAX_X = 7
const MAX_Y = 10
var Block = preload("res://prefabs//Block.tscn")
var blocks = []
var running_block_group = null
var running_group = RunningBlockGroup.new(self, Block)

func _process(delta):
	_process_input()


func _process_input():
	var go_dir = 0
	if Input.is_action_pressed("ui_right"):
		go_dir = 1
	elif Input.is_action_pressed("ui_left"):
		go_dir = -1

	if go_dir != 0:
		emit_signal('move', go_dir)

 
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
