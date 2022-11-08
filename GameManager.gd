extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const UNIT_SIZE = 32
const MAX_Y = 10
var Block = preload("res://Block.tscn")
var blocks = []
var running_blocks = []
# Called when the node enters the scene tree for the first time.
func _ready():
	create_block()

func create_block():
	var block = Block.instance()
	block.init()
	block.position.x = 20
	add_child(block)
	running_blocks.append(block)

var state = 'dropin'
func _process(delta):
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
		var done = block.step(delta)
		if done == false:
			alldone = false

	if alldone:
		state = 'dropin'

