class_name Player extends CharacterBody3D

@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var mouse_sensitivity: float = 1
@export_range(0.1,5.0,0.1) var interact_distance: float = 3.0
## Invert the X axis input for the camera.
var invert_camera_x_axis : bool = false
## Invert the Y axis input for the camera.
var invert_camera_y_axis : bool = false



var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var looking_at_object = null
signal clicked(object, player)

@onready var camera: Camera3D = $Camera
# Stores mouse input for rotating the camera in the physics process
var mouseInput : Vector2 = Vector2(0,0)

	
func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if  Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouseInput = event.relative

			look_dir = event.relative * 0.001
			if mouse_captured: _rotate_camera()
		if event is InputEventMouseButton:
			if event.pressed and looking_at_object!=null:
				emit_signal("clicked",looking_at_object,self)
				$Overlay/HandIcon.visible = false
				
		if Input.is_action_just_pressed("ui_cancel"): 
			$Overlay/PauseMenu.visible = true
			release_mouse()
	elif  Input.is_action_just_pressed("ui_cancel"): 
		recapture_camera()
	
func recapture_camera():
	get_viewport().get_camera_3d().current = false
	camera.current = true
	capture_mouse()
	
func _physics_process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("jump"): jumping = true
		#if mouse_captured:_rotate_camera()
		var space_state = get_world_3d().direct_space_state
		var cam = camera
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * interact_distance
		var mask = 2
		var query = PhysicsRayQueryParameters3D.create(origin, end, mask)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		call_deferred("_handle_mouse_interaction",result)
		velocity = _walk(delta) + _gravity(delta) + _jump(delta)
		move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera():
	if invert_camera_x_axis:
		camera.rotation_degrees.y -= mouseInput.x * mouse_sensitivity * -1
	else:
		camera.rotation_degrees.y -= mouseInput.x * mouse_sensitivity

	if invert_camera_y_axis:
		camera.rotation_degrees.x -= mouseInput.y * mouse_sensitivity * -1
	else:
		camera.rotation_degrees.x -= mouseInput.y * mouse_sensitivity

	

	mouseInput = Vector2(0,0)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))



func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("A", "D", "W", "S")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() or is_on_ceiling_only() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func _handle_mouse_interaction(result):
	if result:
		$Overlay/CrossHair.visible=false
		$Overlay/HandIcon.visible = true
		looking_at_object = result.collider
	else:
		$Overlay/CrossHair.visible=true
		$Overlay/HandIcon.visible = false
		looking_at_object = null


func _on_resume_button_pressed() -> void:
	$Overlay/PauseMenu.visible = false
	capture_mouse()


func _on_quit_button_pressed() -> void:
	get_tree().quit() # Replace with function body.
