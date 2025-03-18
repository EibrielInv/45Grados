@tool
extends Node3D

const DISTANCIA:= 52.9 #metros
const CUADROS := 14.0
const CUADROS_POR_SEGUNDO := 25.0
const ALTURA := 1.0

const METROS_POR_FRAME := 7.0 # metros

# Drag coefficient, projectile radius (m), area (m2) and mass (kg).
const c = 0.47 # Esfera
#const c = 0.8 # Cubo
const r = 0.03 # 3 centimetros
const A = PI * r**2
#const A = r**2 # área de un cuadrado
const m = 0.1 # 100 gramos

# Air density (kg.m-3)
const rho_air = 1.28
# For convenience, define  this constant.
const k = 0.5 * c * rho_air * A

#const VELOCIDAD := DISTANCIA / (CUADROS / CUADROS_POR_SEGUNDO) # Metros por segundo
const VELOCIDAD := METROS_POR_FRAME * CUADROS_POR_SEGUNDO # Metros por segundo

# Acceleration due to gravity (m.s-2)
const G := 9.81

const LINE_MATERIAL = preload("res://line_material.tres")
const LINE_MESH = preload("res://line_mesh.res")
	
@export var angulo := 45.0 :
	set(value):
		if value != angulo:
			dirty = true
		angulo = value
		angulo_rad = deg_to_rad(value)

var dirty := true
var angulo_rad := 0.0

# Vars
var p_pos := Vector2.ZERO
var p_vel := Vector2.ZERO
var time := 0.0

var prev_pos := Vector2.ZERO

var world_pos := Vector3.ZERO

func _ready() -> void:
	print(VELOCIDAD)

func _process(delta: float) -> void:
	if not dirty: return
	dirty = false

func clean() -> void:
	for c in get_children():
		c.queue_free()
	# Setup
	p_pos = Vector2.ZERO
	p_vel = Vector2(
		VELOCIDAD * cos(angulo_rad),
		VELOCIDAD * sin(angulo_rad),
	)
	time = 0.0
	prev_pos = Vector2.ZERO
	prev_pos.y = ALTURA

func step(delta: float) -> bool:
	time += delta
	trayectoria(delta)

	var godot_pos := Vector2(-p_pos.x, p_pos.y + ALTURA)

	var line := MeshInstance3D.new()
	var line_mesh := LINE_MESH
	line.mesh = line_mesh
	line.material_overlay = LINE_MATERIAL
	var l_length := godot_pos.distance_to(prev_pos)
	line.scale = Vector3(0.1, 0.1, l_length*0.5)
	#point.radius = 0.05
	line.position.z = godot_pos.x
	line.position.y = godot_pos.y
	world_pos = line.position
	add_child(line)
	line.look_at(Vector3(0, prev_pos.y, prev_pos.x), Vector3.UP, true)
	prev_pos = godot_pos
	
	if godot_pos.x < -50 and godot_pos.x > -51:
		prints(godot_pos.x, time)
	if godot_pos.y <=0:
		return false
	return true

func trayectoria(dt: float) -> void:
	var F_d = 0.5 * c * rho_air * A * VELOCIDAD**2
	var acc := Vector2(
		-F_d * p_vel.x / (m * VELOCIDAD),
		-G - (F_d * p_vel.y / (m * VELOCIDAD))
	)
	p_vel += acc * dt
	p_pos += p_vel * dt
