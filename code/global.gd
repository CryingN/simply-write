extends Node

var can_draw:bool
var can_write:bool
var can_line:bool
#鼠标绝对位置
var the_mouse_position

# 连线变量
func _ready():
	can_draw = true
	can_write = true
	can_line = true
	pass
