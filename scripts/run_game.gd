extends Node2D

enum GameState {
	CREATING,
	PLAYING,
	DROPING,
	DESTROYING,
	ELLIMNATING,
}

var run_group
var ellimnate_group
var XBlock = preload("res://prefabs/XBlock.tscn")
var blocks = []
func _ready():
	GameManager.connect("keydown", self, "handle_keydown")
	GameManager.connect("keypress", self, "handle_keypress")
	run_group = RunGroup.new(self, XBlock)
	ellimnate_group = EllimnateGroup.new()
	state = GameState.CREATING

var key =''
var state

func _process(delta):
	if state == GameState.CREATING:
		creating()
	elif state == GameState.PLAYING:
		playing(delta)
	elif state == GameState.DESTROYING:
		destroying()
	elif state == GameState.ELLIMNATING:
		ellimnating(delta)

func creating():
	run_group.create()
	state = GameState.PLAYING

var fastmode = false
func playing(delta):
	if key == 'left':
		run_group.move(-1)
	elif key == 'right':
		run_group.move(1)
	elif key == 'rotate':
		run_group.go_rotate()

	fastmode = keypress == 'speed'
	keypress = ''
	key = ""

	var stop = not run_group.run(delta * 6 if fastmode else delta)
	if stop:
		state = GameState.DESTROYING

var keypress = ''
func handle_keypress(key):
	keypress = key

func destroying():
	ellimnate_group.match(run_group_free_group())

func ellimnating():
	ellimnate_group.drop()

func check(x, y):
	if x < 0 || x > GameManager.MAX_X || y < 0 || y > GameManager.MAX_Y:
		return true

	for block in blocks:
		var pos = block.grid_pos
		if pos.x == x and abs(pos.y - y) <= 1: 
			return block
	return null

func handle_keydown(keydown):
	key = keydown 