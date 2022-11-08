extends Sprite

signal block_added

var speed = 48 
var target_y = 0
var step_y = 0
func _ready():
	emit_signal("block_added", self)

func init():
	pass

func to_target():
	if step_y >= GameManager.MAX_Y || checked(0, -1):
		return false
	target_y = position.y + 24

func step(delta):
	position.y += delta * speed
	if position.y >= target_y:
		position.y = target_y
		step_y += 1
		return true
	return false

func checked():
	pass