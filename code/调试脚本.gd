extends Node2D

var draw:bool
var line
var move_camera:bool
var the_text
var local
var the_ligature
var new_text = preload('res://scene//new_text.tscn')
var new_ligature = preload('res://scene//ligature.tscn')

onready var move = get_node("move")

func _ready():
	create_ligature(position)
	draw = false
	move_camera = false
	#定义背景颜色
	VisualServer.set_default_clear_color(Color(0.7, 0.7, 0.7, 1))
	pass

# 创建新的文本
func create_text(vector):
	the_text = new_text.instance()
	the_text.position = vector
	add_child(the_text)
	pass
	
# 创建新的关系连线
func create_ligature(vector):
	the_ligature = new_ligature.instance()
	the_ligature.position = vector
	add_child(the_ligature)
	pass

# 鼠标捕捉：画笔设置， 移动镜头
func _input(event):
	Global.the_mouse_position = (get_global_mouse_position() - position) / scale
	# 画笔设置 
	if draw and Global.can_draw:
		brush(line)
		line.add_point(Global.the_mouse_position)
		pass
	# 移动镜头
	if move_camera:
		position += get_local_mouse_position() - local
		pass
	# 画笔设置(左键)
	if event is InputEventMouseButton and event.button_index == BUTTON_MASK_LEFT:
		if event.pressed:
			line = Line2D.new()
			add_child(line)
		draw = event.pressed
		pass
	# 移动镜头(右键)
	if event is InputEventMouseButton and event.button_index == BUTTON_MASK_RIGHT:
		local = get_local_mouse_position()
		move_camera = not move_camera
		pass
	# 移动镜头(放大缩小)
	if event is InputEventMouseButton:
		if event.button_index == 4:
			local = get_local_mouse_position() - position
			position -= local * 0.05
			scale += Vector2(0.05, 0.05)
			pass
		elif event.button_index == 5:
			local = get_local_mouse_position() - position
			position += local * 0.05
			if scale.x > 0.6:
				scale -= Vector2(0.05, 0.05)
			pass

# 笔刷设置
func brush(something):
	something.default_color = Color(0, 0, 0, 1)
	something.joint_mode = 2
	something.begin_cap_mode = 2
	something.end_cap_mode = 2
	something.width = 2
	something.antialiased = true
	pass

# 复位
func _on_reset_pressed():
	position = Vector2(0,0)
	scale = Vector2(1,1)
	pass

# 文本模式
func _on_text_pressed():
	create_text(get_global_mouse_position() + Vector2(50, 100) - position)
	pass


func _on_connect_pressed():
	create_ligature(get_global_mouse_position() + Vector2(50, 100) - position)
	pass
