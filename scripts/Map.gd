extends Node2D
var blocks = []

const EMPTY_BLOCK = {
	'grid_pos': Vector2(-1, -1),
	'ctype': -1,
}

func append_blocks(_blocks):
	blocks.append_array(_blocks)

func query_pos(x, y):
	if x < 0 || x > GameManager.MAX_X || y < 0 || y > GameManager.MAX_Y:
		return EMPTY_BLOCK

	for block in blocks:
		var pos = block.grid_pos
		if pos.x == x and abs(pos.y - y) <= 1: 
			return block
	return null

func removes(_rm_blocks: Array):
	var indexes = []
	_rm_blocks.sort_custom(self, 'cmp')
	blocks.sort_custom(self, 'cmp')
	var rm_index = 0
	var index = 0
	while index < blocks.size() \
		and rm_index < _rm_blocks.size():
		var rm_block = _rm_blocks[rm_index]
		var block = blocks[index]
		var cmp_res = cmp(rm_block, block)
		if rm_block == block:
			indexes.append(index)
			index += 1
			rm_index += 1
		elif cmp_res and rm_index:
			rm_index += 1
		else:
			index += 1

	for i in range(indexes.size() - 1, 0, -1):
		blocks[i].queue_free()
		blocks.pop_at(i)		

func remove(rm_block):
	var index = blocks.find(rm_block)
	if index >= 0:
		blocks[index].queue_free()
		blocks.remove(index)

func cmp(a, b):
	var dx = a.grid_pos.x - b.grid_pos.x
	var dy = 0
	if dx == 0:
		dy = a.grid_pos.y - b.grid_pos.y
	return dx >= 0 and dy >= 0
