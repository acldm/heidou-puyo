extends Node2D


var Block = preload("res://prefabs//Block.tscn")
var group = null


func _ready():
	group = RunningBlockGroup.new(self, Block)
	group.create_by_pos(3, 3)
	print ("load", group.blocks)
	add_block(5, 7)


func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		group.go_rotate()
	group.step(delta)


func add_block(x, y):
	var block = Block.instance()
	block.init_pos(x, y)
	add_child(block)
	GameManager.append_block(block)
