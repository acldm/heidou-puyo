class_name Block
extends Node2D

signal block_added

export var size = 24 
var speed = 2 
var hor_speed = 8
var target_x = 0
var target_y = 0
var step_y = 0
var step_x = 0
var to_target_done = true
var to_target_x_done = true
var x_speed = 0
var is_stop = false
var is_left = false

func _ready():
	emit_signal("block_added", self)

func init(x, y=0):
	step_x = x
	step_y = y
	position.x = x * size
	position.y = y * size

func to_target(new_speed = 2):
	speed = new_speed * size 
	if is_stop:
		return false
		
	print(step_x, '- -',step_y)
	if GameManager.check(step_x, step_y + 1):
		is_stop = true
		return false
	target_y = position.y + size
	to_target_done = false
	return not is_stop

func hor_move(dir):
	if not to_target_x_done:
		return

	var target_step_x = step_x + dir
	if (target_step_x == GameManager.MAX_X or target_step_x == 0) and GameManager.check(target_step_x, step_y) != null:
		return

	target_x = target_step_x * size
	var rest_y_dist = abs(target_y - position.y) / speed
	var x_dist = abs(target_x - position.x) / hor_speed
	if rest_y_dist < x_dist and GameManager.check(step_x, step_y + 1) != null:
		return

	to_target_x_done = false
	x_speed = dir * hor_speed * size

func step(delta):
	if to_target_done == true:
		return true

	if not to_target_done:
		position.y += delta * speed
		if position.y >= target_y:
			position.y = target_y
			step_y += 1
			to_target_done = true

	if not to_target_x_done:
		position.x += delta * x_speed
		var d = sign(x_speed)
		var ds = position.x >= target_x if d == 1 else position.x <= target_x
		if ds:
			position.x = target_x
			step_x += d 
			to_target_x_done = true

	return false

func is_stopped():
	return is_stop
