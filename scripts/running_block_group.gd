class_name RunningBlockGroup

var Block = null
var parent : Node2D = null
var left_block : Block = null
var right_block : Block = null

func _init(_parent, block):
  parent = _parent
  Block = block

func create():
  _generate_running() 

func step():
  pass 

func _generate_running():
  left_block = _create_block(4, 0)
  right_block = _create_block(5, 0)


func _create_block(x, y):
  var block = Block.instance() 
  block.init(x, y)
  parent.add_child(block)
  return block



