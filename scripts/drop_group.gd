class_name DropGroup

var total_delta = 0
var moved_blocks = []

func drop_ready():
	moved_blocks = []

func droping(delta):
	total_delta += delta
	if total_delta > 0.1:
		total_delta -= 0.1
		return drop_step()
	return true

func drop_step():
	var has_move = false
	for block in Map.blocks:
		if not Map.query_pos(block.grid_pos.x, block.grid_pos.y + 1):
			has_move = true
			block.move(0, 1)
	return has_move

func sort_blocks_by_yaxis(a, b):
	return a.gridpos.y < b.gridpos.y
