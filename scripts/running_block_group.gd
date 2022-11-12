class_name RunningBlockGroup

enum Direction {
	LEFT,
	UP,
	RIGHT
	DOWN,
}

const DIRECTION_LEN = 4
var parent : Node2D = null
var left_block : Block = null
var right_block : Block = null
var block_res = null
var blocks setget ,get_blocks
var direction = Direction.LEFT

func get_blocks():
	return [left_block, right_block]

func _init(_parent, _block_res):
	parent = _parent
	block_res = _block_res


func create():
	create_by_pos(4, 0)


func create_by_pos(x, y):
	left_block = _create_block(x, y)
	right_block = _create_block(x + 1, y)


func move(dir):
	if (
		dir == 0 \
		or not \
		(
			left_block.can_move(dir)\
			and right_block.can_move(dir)
		)):	
		return

	left_block.move(dir)
	right_block.move(dir)

func get_next_direction():
	return direction


var rotating = false
func go_rotate(delta):	
	# var next_direction = (direction + 1 % DIRECTION_LEN)
	left_block.do_rotate(delta, right_block)


var run_delta = 0
func step(delta):
	run_delta += delta

	for block in get_blocks():
		block.uplogic(delta)

	if run_delta < 0.3:
		return

	run_delta = 0
	var allstop = true
	for block in get_blocks():
		if block.step():
			allstop = false
		
	return allstop


func free_blocks():
	var cs = get_blocks()
	left_block = null
	right_block = null
	return cs


func _create_block(x, y):
	var block = block_res.instance()
	block.init_pos(x, y)
	parent.add_child(block)
	return block

