extends Area2D

### GLOBAL ###
@onready var global = get_node("/root/global")

### SPRITE NODES ###
@onready var sprite = $Sprite2D

### TEXTURES ###
@export var regular_texture : Texture2D 
@export var transparent_texture : Texture2D

### VARIABLES ###
enum status {hidden, transparent, regular}
var current_status : status = status.hidden
var collected = false
var saved = false #changed to true only with global function

### BUILT IN FUNCTIONS ###
func _ready():
	hidden()

func _physics_process(_delta):
	if current_status == status.transparent and global.light_active:
		regular()
	elif current_status == status.regular and !global.light_active:
		transparent()

### CUSTOM FUNCTIONS ###
func save():
	saved = true

func respawn():
	hidden()
	collected = false

func hidden():
	sprite.visible = false
	current_status = status.hidden

func transparent():
	if !collected:
		sprite.texture = transparent_texture
		sprite.visible = true
		current_status = status.transparent

func regular():
	if !collected:
		sprite.texture = regular_texture
		sprite.visible = true
		current_status = status.regular
