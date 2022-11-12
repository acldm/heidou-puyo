extends Node2D


var Block = preload("res://prefabs//Block.tscn")
var group = null


func _ready():
	group = RunningBlockGroup.new(self, Block)
	group.create_by_pos(3, 3)
	print ("load", group.blocks)


func _process(delta):
	group.go_rotate(delta)
	group.step(delta)
