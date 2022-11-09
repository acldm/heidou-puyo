extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const UNIT_SIZE = 32
const MAX_Y = 10
var Block = preload("res://Block.tscn")
var blocks = []
var running_blocks = []
var go_dir  = false
# Called when the node enters the scene tree for the first time.
func _ready():
	create_block(4)
	create_block(5)

func create_block(x):
	var block = Block.instance()
	block.init(x)
	add_child(block)
	running_blocks.append(block)

var state = 'dropin'
func _process(delta):
	_process_input()
	if state == 'dropin':
		_drop_ready()	
	elif state == 'droping':
		droping(delta)

func _drop_ready():
	for block in running_blocks:
		block.to_target()
	self.state = 'droping'

func droping(delta):
	var alldone = true

	for block in running_blocks:
		if go_dir != 0:
			block.hor_move(go_dir)
		var done = block.step(delta)
		if done == false:
			alldone = false

	if alldone:
		state = 'dropin'

func _process_input():
	go_dir = 0
	if Input.is_action_just_pressed("ui_right"):
		go_dir = 1
	elif Input.is_action_just_pressed("ui_left"):
		go_dir = -1


func check(x, y):
	for block in blocks:
		if blocks.step_x == x and blocks.step_y == y:
			return block
	return null
