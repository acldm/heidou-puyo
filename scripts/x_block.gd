extends Sprite

var animating = false
var grid_pos
var x_size = 24
var y_size = x_size / 2
var color

func _init():
	grid_pos = Vector2(-100, -100)

func set_pos(pos: Vector2):
	grid_pos = pos

func move(offset_x, offset_y = 0):
	grid_pos.x += offset_x
	grid_pos.y += offset_y

func _process(delta):
	if animating:
		animate_step(delta)
	else:
		position = render_pos()
	
func render_pos():
	return get_pos_by_grid(grid_pos)

func get_pos_by_grid(grid_pos):
	return Vector2(
		grid_pos.x * x_size,
		grid_pos.y * y_size
	)

var anim_offset_pos:Vector2
var deg = 0
var center = null
func play_rotate(offset, center_obj):
	grid_pos += offset
	deg = 0
	animating = true
	center = center_obj
	anim_offset_pos = offset

func animate_step(delta):
	deg += PI * delta * 3
	print(deg, delta)
	if deg > PI / 2:
		animating = false
	position = around_point_rotate(deg, get_pos_by_grid(grid_pos - anim_offset_pos), center.render_pos())

func around_point_rotate(deg, op, tp):
	var nx = (op.x - tp.x) * cos(deg) - (op.y - tp.y) * sin(deg) + tp.x
	var ny = (op.x - tp.x) * sin(deg) + (op.y - tp.y) * cos(deg) + tp.y
	return Vector2(nx, ny)

