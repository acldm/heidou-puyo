extends Node2D

enum GameState {
	CREATING,
	PLAYING,
	DROPPING,
	ELLIMNATING,
}

var run_group: RunGroup
var ellimnate_group: EllimnateGroup
var drop_group: DropGroup
var XBlock = preload("res://prefabs/Block.tscn")
var blocks = []
func _ready():
	GameManager.connect("keydown", self, "handle_keydown")
	GameManager.connect("keypress", self, "handle_keypress")
	run_group = RunGroup.new(self, XBlock)
	ellimnate_group = EllimnateGroup.new()
	drop_group = DropGroup.new()
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
	if reg_blocks.size() == 0:
		state = GameState.CREATING
	else:
		Map.append_blocks(reg_blocks)
		ellimnate_group.match(reg_blocks)
		state = GameState.ELLIMNATING	

func ellimnating(delta):
	var es = ellimnate_group.ellimnating(delta)
	if not es:
		enter_drop_state()
	
func enter_drop_state():
	drop_group.drop_ready()
	state = GameState.DROPPING
	
func dropping (delta):
	if not drop_group.droping(delta):
		enter_ellimnate_state(drop_group.moved_blocks)

func handle_keydown(keydown):
	key = keydown 

var keypress = ''
func handle_keypress(key):
	keypress = key
