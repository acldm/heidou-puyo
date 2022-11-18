extends Node2D
var blocks = []
var block_id_index_maps = {}
var block_index_yaxis_maps = {}
const EMPTY_BLOCK = {
	'grid_pos': Vector2(-1, -1),
	'ctype': -1,
}

func append_block(_block: Block):
	var instance_id = _block.get_instance_id()
	if block_id_index_maps.has(instance_id):
		return false
	blocks.append(_block)
	block_id_index_maps[instance_id] = _block
	return true
	
func append_blocks(blocks):
	for block in blocks:
		append_block(block)

func query_pos(x, y):
	if x < 0 || x > GameManager.MAX_X || y < 0 || y > GameManager.MAX_Y:
		return EMPTY_BLOCK

	for block in blocks:
		var pos = block.grid_pos
		var dy = pos.y - y
		if pos.x == x and (dy == 0 or dy == -1): 
			return block
	return null
	
func check_adjust(block, offset_x, offset_y):
	offset_y *= 2
	return query_pos(block.grid_pos.x + offset_x, block.grid_pos.y + offset_y)

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
		elif cmp_res:
			rm_index += 1
		else:
			index += 1
	
	print(indexes)
	for i in range(indexes.size() - 1, -1, -1):
		var ri = indexes[i]
		blocks[ri].queue_free()
		blocks.pop_at(ri)		

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
