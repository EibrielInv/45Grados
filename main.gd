extends Node3D

# "Daeji Car GWC 6500 (Police Water Cannon Truck)" (https://skfb.ly/owRUN) by drcrazzie is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
# "Photographer" (https://skfb.ly/6WQQx) by nolanfa is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
# "Futuristic soldier (lowpoly)" (https://skfb.ly/oSVPA) by SlagPerch 3D is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).

var angulo := 0.0
var simulando := false

func _ready() -> void:
	angulo = %AnguloSlider.value
	update_ui()

func _process(delta: float) -> void:
	var vel_kmh:float = $Trayectoria.p_vel.length() * 0.277778
	%VelocidadLabel.text = "%.1f Km/h" % vel_kmh
	%HoraLabel.text = "17:18:%02.2f" % $Trayectoria.time
	
	%CameraTrack.position.z = $Trayectoria.world_pos.z * 0.8
	%CameraTrack.position.y = $Trayectoria.world_pos.y * 0.5
	%CameraTrack.rotation_degrees.y = remap($Trayectoria.world_pos.z, 0, -50, -5, -40)
	#print($Trayectoria.world_pos.z)
	%Camera3D.position.x = -$Trayectoria.world_pos.y + -40.0
	#$Camera3D.unproject_position($Trayectoria.world_pos)

func _physics_process(delta: float) -> void:
	var simulation_speed := remap(angulo, 0, 45, 0.1, 1.0)
	if simulando:
		simulando = $Trayectoria.step(delta*simulation_speed)

func update_ui() -> void:
	%AnguloLabel.text = "%dº" % angulo

func _on_h_slider_value_changed(value: float) -> void:
	angulo = %AnguloSlider.value
	update_ui()

func _on_calcular_button_pressed() -> void:
	$Trayectoria.angulo = angulo
	$Trayectoria.clean()
	simulando = true

func _on_reset_button_pressed() -> void:
	%AnguloSlider.value = 1
