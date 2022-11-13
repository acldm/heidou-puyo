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


class TurnData:
	var parent_offset: Vector2
	var can_turn: bool
	var offset: Vector2


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
func go_rotate():	
	if left_block.rotating:
		return

	var turn_data = null
	var next_direction = (direction + 1 % DIRECTION_LEN)
	if next_direction == Direction.UP:
		print('to up')
		turn_data = is_up_turn()

	run_rotate(turn_data)


func run_rotate(turn_data):
	if not turn_data.can_turn:
		return

	if turn_data.parent_offset:
		left_block.update_offset(turn_data.parent_offset)
		right_block.update_offset(turn_data.parent_offset)

	left_block.play_rotate(right_block, turn_data.offset)


func is_up_turn():
	var turn_data = TurnData.new()
	turn_data.can_turn = GameManager.check(right_block.step_x, right_block.step_y - 1) == null
	turn_data.offset = Vector2(1, -1)
	return turn_data
	

# func is_right_turn():
# 	var block = GameManager.check(step_x + 1, step_y)
# 	var turn_data = TurnData.new()
# 	turn_data.offset = Vector2(1, -1)
# 	if not block:
# 		block = check_left_exist()
# 		if not block:
# 			turn_data.parent_offset = Vector2(-1, 0)
# 	turn_data.can_turn = block != null
# 	return turn_data


# func is_down_turn():
# 	return GameManager.check(step_x, step_y - 1)


# func is_left_turn():
# 	return GameManager.check(step_x, step_y + 1)


func check_left_exist():
	return GameManager.check(right_block.step_x - 1, right_block.step_y)

var run_delta = 0
func step(delta):
	run_delta += delta

	for block in get_blocks():
		block.uplogic(delta)

	left_block.rotate_step(delta)

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

