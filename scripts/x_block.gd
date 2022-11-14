extends Sprite

var animating = false
var grid_pos
var x_size = 24
var y_size = x_size / 2

func _init():
	grid_pos = Vector2(-100, -100)

func set_pos(pos: Vector2):
	grid_pos = pos

func move(offset_x):
	grid_pos.x += offset_x

func step():
	grid_pos.y += 1

func _process(delta):
	if animating:
		animate_step(delta)
	else:
		position.x = grid_pos.x * x_size
		position.y = grid_pos.y * y_size
	
func animate_step(delta):
	pass
