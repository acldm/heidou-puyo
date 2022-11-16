extends Node

enum GameState {
	CREATING,
	PLAYING,
	DROPING,
	DESTROYING,
}

var Block = preload("res://prefabs//Block.tscn")
var running_block_group = null
var state = GameState.DROPING
var running_group = RunningBlockGroup.new(self, Block)
var go_dir = 0


func _ready():
	running_block_group = RunningBlockGroup.new(self, Block)
	# add_block(0, 1)
	# add_block(0, 2)
	# add_block(0, 3)
	# add_block(0, 4)
	# add_block(0, 5)
	# add_block(0, 6)
	# add_block(0, 7)
	# add_block(0, 1)
	# add_block(2, 7)
	# add_block(3, 7)
	# add_block(4, 7)
	# add_block(7, 7)
	# add_block(2, 6)
	# add_block(3, 6)
	# add_block(3, 5)
	GameManager.connect("keydown", self, "handle_keydown")
	state = GameState.CREATING


func _process(delta):
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
	GameManager.append_blocks(stoped_blocks)
	state = GameState.CREATING


func playing(delta):
	if keydown == 'left':
		running_block_group.move(-1)
	elif keydown == 'right':
		running_block_group.move(1)
	elif keydown == 'rotate':
		running_block_group.go_rotate()

	keydown = ""

	var running = running_block_group.step(delta)
	if not running:
		state = GameState.DESTROYING


func add_block(x, y):
	var block = Block.instance()
	block.init_pos(x, y)
	add_child(block)
	GameManager.append_block(block)

var keydown = ""
func handle_keydown(key):
	keydown = key
