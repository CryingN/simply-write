extends Node2D

var move:bool
var y_mid
var position_text
onready var textedit = get_node("TextEdit")
onready var left_area = get_node("left_Area2D")
onready var right_area = get_node("right_Area2D")


func _ready():
	move = false
	textedit.text = '#'
	pass

func _on_Button_pressed():
	move = not move
	pass

func _process(delta):
	textedit.readonly = not Global.can_write
	position_text = textedit
	if move:
		position += get_local_mouse_position()
	left_area.position = Vector2(0, 30)
	right_area.position = Vector2(textedit.rect_size.x, 30)
	pass



