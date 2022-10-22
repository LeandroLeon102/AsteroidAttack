extends Node2D

onready var crosshair_cursor1 = load("res://Resources/Images/crosshair038.png")
onready var crosshair_cursor2 = load("res://Resources/Images/crosshair037.png")
onready var mouse_cursor = load("res://Resources/Images/cursor_pointer3D_shadow.png")


func _ready():
	$Sprite.texture = crosshair_cursor1
	
func _physics_process(delta):
	position = get_global_mouse_position()
