class_name Block
extends Node2D

signal block_added

export var size = 24 
var target_x = 0
var target_y = 0
var step_y = 0
var step_x = 0
var is_stop = false
var is_left = false

func _ready():
	emit_signal("block_added", self)

func init_pos(x, y=0):
	step_x = x
	step_y = y
	position.x = x * size
	position.y = y * size

func can_move(dir):
	if is_stop:
		return true

	var check_y = step_y + dy 
	if move_cd < MoveCD\
		or GameManager.check(step_x + dir, check_y) != null:
		return false

	return true


const MoveCD = 0.1
var move_cd = 0
func move(dir):
	move_cd = 0

	if is_stop:
		return

	position.x += dir * size
	step_x += dir

func uplogic(delta):
	move_cd += delta


func step():
	if target_x != 0:
		step_x += target_x
		target_x = 0

	if not can_drop():
		return false
	
	drop()
	return true


func can_drop():
	var _can_drop = not is_stop\
		and GameManager.check(step_x, step_y + 1) == null
	if not _can_drop:
		step_stop()
	return _can_drop

func step_stop():
	is_stop = true

# y分量
var dy = 0
func drop():
	dy += 1
	if (dy > 1):
		dy = 0
		step_y += 1
	position.y += size / 2


var total_radian = 0
var parent_handle = null
var rotating = false


func play_rotate(obj, offset):
	rotating = true
	parent_handle = obj
	total_radian = 0
	step_x += offset.x
	step_y += offset.y


func rotate_step(delta):
	if not rotating:
		return
		 
	var radian = PI * delta * 4
	total_radian += radian
	if total_radian > PI / 2:
		rotating = false
		resize_step_pos()
	else:
		var offset_pos = around_point_rotate(radian, position, parent_handle.position)
		position = offset_pos


func resize_step_pos():
	position.x = step_x * size
	position.y = step_y * size
	if dy > 0:
		position.y += size / 2


func around_point_rotate(deg, op, tp):
	var nx = (op.x - tp.x) * cos(deg) - (op.y - tp.y) * sin(deg) + tp.x
	var ny = (op.x - tp.x) * sin(deg) + (op.y - tp.y) * cos(deg) + tp.y
	return Vector2(nx, ny)


func is_stopped():
	return is_stop


func update_offset(offset):
		step_x += offset.x
		step_y += offset.y
		position.x = step_x * size	
		position.y = step_y * size	
