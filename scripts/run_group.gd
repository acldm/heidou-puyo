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

func _init(_parent, _block_res):
	parent = _parent
	block_res = _block_res

func create():
	a_block = _create_block(Vector2(4, 0))
	c_block = _create_block(Vector2(5, 0))

func _create_block(pos):
	var block = block_res.instance()
	block.set_pos(pos)
	parent.add_child(block)
	return block


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

	a_block.move(dir)
	c_block.move(dir)
	
func has_group_move(dir):
	var block = a_block if dir == -1 else c_block
	return is_block_exists(block.grid_pos.x + dir, block.grid_pos.y) == null	
	

func step():
	if has_group_drop_collision():
		return false

	var is_a_stop = iter_step(a_block)
	var is_c_stop = iter_step(c_block)
	return is_a_stop or is_c_stop

func iter_step(block):
	if is_block_exists(block.grid_pos.x, block.grid_pos.y + 2) == null:
		block.step()
		return true
	return false


func has_group_drop_collision():
	if direction == Direction.UP:
		is_block_exists(c_block.grid_pos.x, c_block.grid_pos.y) == null
	return false

func is_block_exists(x, y):
	return parent.check(x, y)

func is_block_hor_exists(block):
	# return parent.check()
	pass
	

func free_group():
	return [a_block, c_block]
