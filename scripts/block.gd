class_name Block

extends Sprite

var animating = false
var grid_pos
var x_size = 16
var y_size = x_size / 2
var ctype = 1

func _init(init_ctype = 1):
	ctype = randi() % 4
	texture = Types.CTYPE_TEXTURES[ctype]
	grid_pos = Vector2(-100, -100)

func set_pos(pos: Vector2):
	grid_pos = pos

func move(offset_x, offset_y = 0):
	grid_pos.x += offset_x
	grid_pos.y += offset_y

func _process(delta):
	modulate.a = 0.2 if flashing else 1
		
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
	if deg > PI / 2:
		animating = false
	position = around_point_rotate(deg, get_pos_by_grid(grid_pos - anim_offset_pos), center.render_pos())

func around_point_rotate(deg, op, tp):
	var nx = (op.x - tp.x) * cos(deg) - (op.y - tp.y) * sin(deg) + tp.x
	var ny = (op.x - tp.x) * sin(deg) + (op.y - tp.y) * cos(deg) + tp.y
	return Vector2(nx, ny)

var flashing = false
func flash():
	flashing = !flashing
#	tween.interpolate_property($Sprite, "modulate.a",
#        Vector2(0, 0), Vector2(100, 100), 1,
#        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#
	
