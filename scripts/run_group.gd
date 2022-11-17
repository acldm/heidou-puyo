class_name RunGroup

enum Direction {
	LEFT,
	UP,
	RIGHT
	DOWN,
}

var parent: Node2D
var block_res
var a_block
var c_block
var direction = Direction.LEFT
const DIRECTION_LEN = 4

func _init(_parent, _block_res):
	parent = _parent
	block_res = _block_res

func create():
	direction = Direction.LEFT
	a_block = _create_block(Vector2(4, 0))
	c_block = _create_block(Vector2(5, 0))

func _create_block(pos):
	var block = block_res.instance()
	block.set_pos(pos)
	parent.add_child(block)
	return block

var rotate_funcs = ["rotate_left", "rotate_up", "rotate_right", "rotate_down"]
func go_rotate():
	if a_block.animating:
		return
	var next_direction = (direction + 1) % DIRECTION_LEN
	var offset = call(rotate_funcs[next_direction])
	if offset:
		a_block.play_rotate(offset, c_block)
		direction = next_direction
	
func rotate_up():
		return Vector2(1, -2)

func rotate_right():
	var block = is_block_exists(c_block, 1, 0)
	if block:
		block = is_block_exists(c_block, -1, 0)
	if not block:
		c_block.move(-1, 0)
		a_block.move(-1, 0)
	else:
		return null
	return Vector2(1, 2) 

func rotate_left():
	var block = is_block_exists(c_block, -1, 0)
	if block:
		block = is_block_exists(c_block, 1, 0)
	if not block:
		c_block.move(1, 0)
		a_block.move(1, 0)
	else:
		return null
	return Vector2(-1, -2) 

func rotate_down():
	var block = is_block_exists(c_block, 0, 1)
	if block:
		return null
	return Vector2(-1, 2)

var total_time = 0
func run(delta):
	var result = true
	total_time += delta
	if total_time > 0.3:
		total_time -= 0.3
		result = step()

	return result

func move(dir):
	if not has_group_move(dir):
		return

	_iter_move(a_block, dir)
	_iter_move(c_block, dir)

func _iter_move(block, dir):
	if is_block_exists(block, 0, 1):
		return
	block.move(dir)

func step():
	if has_group_drop_collision():
		return false

	var is_a_stop = iter_step(a_block)
	var is_c_stop = iter_step(c_block)
	return is_a_stop or is_c_stop

func iter_step(block):
	if is_block_exists(block, 0, 1) == null:
		block.move(0, 1)
		return true
	return false

func has_group_move(dir):
	return is_block_exists(a_block, dir, 0) == null\
		and is_block_exists(c_block, dir, 0) == null

func has_group_drop_collision():
	if direction == Direction.UP:
		return is_block_exists(c_block, 0, 1) != null
	elif direction == Direction.DOWN:
		return is_block_exists(a_block, 0, 1) != null
	return false

func is_block_exists(block, x = 0, y = 0):
	return Map.check_adjust(block, x, y)
	
func free_group():
	return [a_block, c_block]
