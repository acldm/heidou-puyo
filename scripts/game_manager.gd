extends Node2D
enum GameState {
	CREATING,
	PLAYING,
	DROPING,
	DESTROYING,
}

const UNIT_SIZE = 32
const MAX_X = 7
const MAX_Y = 7
var Block = preload("res://prefabs//Block.tscn")
var blocks = []
var running_block_group = null
var go_dir  = false
var state = GameState.DROPING
var running_group = RunningBlockGroup.new(self, Block)

func _ready():
	running_block_group = RunningBlockGroup.new(self, Block)
	state = GameState.CREATING
	add_block(2, 7)
	add_block(3, 7)
	add_block(4, 7)
	add_block(7, 7)
	add_block(2, 6)
	add_block(3, 6)
	add_block(3, 5)


func _process(delta):
	_process_input()
	if state == GameState.CREATING:
		creating()
	elif state == GameState.PLAYING:
		playing(delta)
	elif state == GameState.DESTROYING:
		destroying()


func creating():
	running_block_group.create()
	state = GameState.PLAYING


func destroying():
	var stoped_blocks = running_block_group.free_blocks()
	blocks.append_array(stoped_blocks)
	state = GameState.CREATING


func add_block(x, y):
	var block = Block.instance()
	block.init(x, y)
	add_child(block)
	blocks.append(block)


func playing(delta):
	if go_dir != 0:
		running_block_group.move(go_dir)
	var is_all_stop = running_block_group.step(delta)
	if is_all_stop:
		state = GameState.DESTROYING


func _process_input():
	go_dir = 0
	if Input.is_action_pressed("ui_right"):
		go_dir = 1
	elif Input.is_action_pressed("ui_left"):
		go_dir = -1

func check(x, y):
	if x < 0 || x > MAX_X || y < 0 || y > MAX_Y:
		return true

	for block in blocks:
		if block.step_x == x and block.step_y == y:
			return block
	return null
