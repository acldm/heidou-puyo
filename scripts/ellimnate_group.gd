class_name EllimnateGroup

var blocks = []

func append_blocks(_blocks)
	blocks.append_array(_blocks)

func drop(delta):
	pass

func match(blocks):
	append_blocks(blocks)
	var nodes = blocks
	var accessed = []
	start_node = [nodes[0]]
	for node in nodes:
		if node in accessed:
			return
		
func _match_iter(start_node):
	k