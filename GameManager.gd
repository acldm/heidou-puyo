extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const UNIT_SIZE = 32
const MAX_X = 7
const MAX_Y = 7
var Block = preload("res://Block.tscn")
var blocks = []
var running_blocks = []
var go_dir  = false
var state = 'dropin'
# Called when the node enters the scene tree for the first time.
func _ready():
	state = 'creating'
func create_block(x, y = 0):
	var block = Block.instance()
	block.init(x, y)
	add_child(block)
	blocks.append(block)
	running_blocks.append(block)

func _process(delta):
	_process_input()
	if state == 'creating':
		creating()
	elif state == 'droping':
		droping(delta)

func _drop_ready():
	state = 'droping'
	for block in running_blocks:
		block.to_target()

func creating():
	create_block(4)
	create_block(5)
	state = 'droping'

func droping(delta):
	var alldone = true

	if go_dir != 0:
		for block in running_blocks:
				block.hor_move(go_dir)

	for block in running_blocks:
		var done = block.step(delta)
		if done == false:
			alldone = false

	if alldone:
		for block in running_blocks:
			block.to_target()
		
	var allstop = true
	for block in running_blocks:
		if not block.is_stopped():
			allstop = false
	if allstop:
		state = 'creating'

func _process_input():
	go_dir = 0
	if Input.is_action_pressed("ui_right"):
		go_dir = 1
	elif Input.is_action_pressed("ui_left"):
		go_dir = -1

func dis_running_blocks():
	blocks.append_array(running_blocks)
	running_blocks = []

func check(x, y):
	for block in blocks:
		if block.step_x == x and block.step_y == y:
			return block
	return null
