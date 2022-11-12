class_name RunningBlockGroup

enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

var parent : Node2D = null
var left_block : Block = null
var right_block : Block = null
var block_res = null
var blocks setget ,get_blocks

func get_blocks():
	return [left_block, right_block]

func _init(_parent, _block_res):
	parent = _parent
	block_res = _block_res


func create():
	_generate_running()


func move(dir):
	if (
		not \
		(
			left_block.can_move(dir)\
			and right_block.can_move(dir)
		)):	
		return

	left_block.move(dir)
	right_block.move(dir)


func step(delta):
	var allstop = true
	for block in get_blocks():
		if block.step(delta):
			allstop = false
		
	return allstop


func free_blocks():
	var cs = get_blocks()
	left_block = null
	right_block = null
	return cs


func _generate_running():
	left_block = _create_block(4, 0)
	right_block = _create_block(5, 0)


func _create_block(x, y):
	var block = block_res.instance()
	block.init(x, y)
	parent.add_child(block)
	return block



