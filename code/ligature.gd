extends Line2D

var delta_position
var move:bool
var right_move:bool
var points_zero
var delta_move_left
var delta_move_right
var left_tile:bool
var right_tile:bool

onready var left = get_node("left_Area2D")
onready var right = get_node("right_Area2D")
onready var tween = get_node("Tween")
onready var line = $"."


func _ready():
	left_tile = false
	right_tile = false
	points_zero = points[0]
	move = false
	right_move = true
	delta_position = points[3] - points[0]
	pass

func _process(delta):
	if move:
		tween.remove_all()
	else:
		if left_tile and (delta_move_left - points[0] - position).length() >= 0.5 :
			move_tile_left(position,delta_move_left - points[0])
			pass
		elif right_tile and (delta_move_right - position - points[3]).length() >= 0.5:
			move_tile_right(points[3],delta_move_right - position)
			right.position = points[3]
			pass
	pass
	
# 绝对移动
func _on_left_Area2D_input_event(viewport, event, shape_idx):
	if move and right_move :
		points_zero = points[0]
		points[0] = Global.the_mouse_position - position
		delta_position = points[0] - points_zero
		left.position = points[0]
		right.position += delta_position
		points[1] += delta_position
		points[2] += delta_position
		points[3] += delta_position	
		pass
	if event is InputEventMouseButton and event.button_index == BUTTON_MASK_LEFT and Global.can_line:
		move = not move
		Global.can_draw = not Global.can_draw
		Global.can_write = not Global.can_write
		pass

# 相对移动
func _on_right_Area2D_input_event(viewport, event, shape_idx):
	if move:
		points[3] = Global.the_mouse_position - position
		right.position = points[3]
		delta_position = points[3] - points[0]
		points[1] = points[0] + delta_position * Vector2(0.5, 0.1)
		points[2] = points[0] + delta_position * Vector2(0.5, 0.9)
		pass
	if event is InputEventMouseButton and event.button_index == BUTTON_MASK_LEFT and Global.can_line:
		move = not move
		right_move = not right_move
		Global.can_draw = not Global.can_draw
		Global.can_write = not Global.can_write
	pass

# 磁铁动画
func move_tile_left(where_to_go,go_where):
	tween.interpolate_property(
		line,"position",
		where_to_go,go_where,
		0.3,tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	tween.start()
	pass

func move_tile_right(where_to_go,go_where):
	tween.interpolate_method(
		line,"move_position",
		where_to_go,go_where,
		0.3,tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	tween.start()
	pass

func move_position(new_pos):
	line.set_point_position(3,new_pos)
	points[1] = points[0] + delta_position * Vector2(0.5, 0.1)
	points[2] = points[0] + delta_position * Vector2(0.5, 0.9)
	pass	

# 左磁铁
func _on_left_Area2D_area_entered(area):
	left_tile = true
	delta_move_left = area.position + area.get_parent().position
	pass


# 右磁铁
func _on_right_Area2D_area_entered(area):
	right_tile = true
	delta_move_right = area.position + area.get_parent().position
	pass

# 左磁铁（离开）
func _on_left_Area2D_area_exited(area):
	left_tile = false
	pass

# 右磁铁（离开）
func _on_right_Area2D_area_exited(area):
	right_tile = false
	pass
