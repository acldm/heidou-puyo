class_name EllimnateGroup

const MATCH_COUNT = 4

class MatchHandler:
	var accessed = []
	func match(start_node):
		if accessed.has(start_node):
			return []
		var wait_visitor = [start_node]
		var result = [start_node]
		accessed.append(start_node)
		var ctype = start_node.ctype
		while not wait_visitor.empty():
			var node = wait_visitor.pop_back()
			_iter_match(node, wait_visitor, ctype, result)
		return result
		
	func _iter_match(node, wait_visitor, ctype, result):
		_add_block_in_visitor_by_pos(node, -1, 0, wait_visitor, ctype, result)
		_add_block_in_visitor_by_pos(node, 1, 0, wait_visitor, ctype, result)
		_add_block_in_visitor_by_pos(node, 0, 1, wait_visitor, ctype, result)
		_add_block_in_visitor_by_pos(node, 0, - 1, wait_visitor, ctype, result)

	func _add_block_in_visitor_by_pos(_node, x, y, wait_visitor, ctype, result):
		var node = Map.check_adjust(_node, x, y)
		if not node or accessed.has(node):
			return

		if node.ctype == ctype:
			wait_visitor.push_front(node)
			accessed.append(node)
			result.append(node)

var results = []
func match(match_blocks):
	results = []
	var match_handler = MatchHandler.new()
	for mblock in match_blocks:
		var result = match_handler.match(mblock)
		if result.size() >= MATCH_COUNT:
			results.append_array(result)

var total_delta = 0
func ellimnating(delta):
	total_delta += delta
	if total_delta > 0.05:
		total_delta -= 0.05
		return ellimnate_step()
	return true

var do_flash_count = 16
func ellimnate_step():
	if results.size() == 0:
		return false
	
	for r in results:
		r.flash()
	do_flash_count -= 1
	if do_flash_count == 0:
		#for r in results:
		#	Map.remove(r)
		Map.removes(results)
		do_flash_count = 16
		return false
	return true
	
