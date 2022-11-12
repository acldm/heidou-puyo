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

func play_rotate_anim():
	pass

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
		is_stop = true
	return _can_drop

# y分量
var dy = 0
func drop():
	dy += 1
	if (dy > 1):
		dy = 0
		step_y += 1
	position.y += size / 2


func do_rotate(delta, obj):
	var angle = PI * delta * 2
	angle = wrapf(angle, -PI, PI)
	go_rotate(angle, obj.position)


func go_rotate(deg, tp):
	var op = position
	var nx = (op.x - tp.x) * cos(deg) - (op.y - tp.y) * sin(deg) + tp.x
	var ny = (op.x - tp.x) * sin(deg) + (op.y - tp.y) * cos(deg) + tp.y
	position.x = nx 
	position.y = ny 


func is_stopped():
	return is_stop
