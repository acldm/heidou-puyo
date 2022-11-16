extends Node2D

enum GameState {
	CREATING,
	PLAYING,
	DROPPING,
	ELLIMNATING,
}

var run_group: RunGroup
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
	elif state == GameState.ELLIMNATING:
		ellimnating(delta)
	elif state == GameState.DROPPING:
		dropping(delta)

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
		var unlink_blocks = run_group.free_group()
		enter_ellimnate_state(unlink_blocks)

func enter_ellimnate_state(reg_blocks):
	Map.append_blocks(reg_blocks)
	ellimnate_group.match(reg_blocks)
	print(ellimnate_group.results)
	state = GameState.ELLIMNATING	

var keypress = ''
func handle_keypress(key):
	keypress = key

func ellimnating(delta):
	var es = ellimnate_group.ellimnating(delta)
	if not es:
		state = GameState.CREATING
	
func dropping (delta):
	if not ellimnate_group.droping(delta):
		state = GameState.ELLIMNATING

func handle_keydown(keydown):
	key = keydown 
