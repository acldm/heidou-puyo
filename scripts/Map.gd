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

func removes(_blocks):
	_blocks.sort_custom(self, "_cmp_desc")
	for b_index in _blocks:
		blocks[b_index].queue_free()
		blocks.remove(b_index)

func _cmp_desc(a, b):
	return a - b > 0
