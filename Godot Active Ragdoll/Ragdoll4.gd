extends Spatial


onready var BodyControl = $BodyControl
onready var LeftLegControl = $LeftLegControl
onready var RightLegControl = $RightLegControl
onready var RightArmControl = $RightArmControl
onready var LeftArmControl = $LeftArmControl

onready var CameraPivot = $CameraPivot

onready var Head = $"Armature001/Skeleton/Physical Bone Head2"
onready var Body = $"Armature001/Skeleton/Physical Bone Body"
onready var LeftArm3 = $"Armature001/Skeleton/Physical Bone LeftArm3"
onready var RightArm3 = $"Armature001/Skeleton/Physical Bone RightArm3"

var Mouse_sensitivity = 0.3

var WalkSpeed = 2

var WalkAnimationTimer = 0
var IsWalking = false

onready var JumpRayCast = $"Armature001/Skeleton/Physical Bone Body/JumpRayCast"
var CanJump = true
var JumpStrength = 50


var LeftHandActive = false
var RightHandActive = false
var LeftHandGrab = null
var RightHandGrab = null

onready var LeftGrabJoint = $"Armature001/Skeleton/Physical Bone LeftArm3/GrabJoint"
onready var RightGrabJoint = $"Armature001/Skeleton/Physical Bone RightArm3/GrabJoint"


func _ready():
	$"Armature001/Skeleton/".physical_bones_start_simulation()
	


func _process(delta):
	CameraPivot.global_transform.origin = Head.global_transform.origin
	
	HandleRotation()
	HandleWalk()
	HandleGrab()
	
func HandleGrab():
	if Input.is_action_pressed("left_mouse"):
		LeftArmControl.rotation.x = CameraPivot.rotation.x*2
		LeftHandActive = true
		
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
	else:
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		LeftArmControl.get_node("Generic6DOFJoint").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		LeftArmControl.get_node("Generic6DOFJoint2").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		
		LeftHandActive = false
		LeftGrabJoint.set_node_a("")
		LeftGrabJoint.set_node_b("")
		LeftHandGrab = null
		
	if Input.is_action_pressed("right_mouse"):
		RightArmControl.rotation.x = CameraPivot.rotation.x*2
		RightHandActive = true

		RightArmControl.get_node("Generic6DOFJoint").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		RightArmControl.get_node("Generic6DOFJoint").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		RightArmControl.get_node("Generic6DOFJoint").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,true)


	else:
		RightArmControl.get_node("Generic6DOFJoint").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightArmControl.get_node("Generic6DOFJoint").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightArmControl.get_node("Generic6DOFJoint").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_x(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_y(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightArmControl.get_node("Generic6DOFJoint2").set_flag_z(Generic6DOFJoint.FLAG_ENABLE_ANGULAR_SPRING,false)
		RightHandActive = false
		RightGrabJoint.set_node_a("")
		RightGrabJoint.set_node_b("")
		RightHandGrab = null

func HandleRotation():
	BodyControl.rotation.y = CameraPivot.rotation.y
	LeftArmControl.rotation.y = CameraPivot.rotation.y
	RightArmControl.rotation.y = CameraPivot.rotation.y
	LeftLegControl.rotation.y = CameraPivot.rotation.y
	RightLegControl.rotation.y = CameraPivot.rotation.y



func HandleWalk():
	IsWalking = false
	
	if Input.is_action_pressed("forward"):
		Body.apply_central_impulse(-BodyControl.transform.basis.z*WalkSpeed)
		IsWalking = true
	if Input.is_action_pressed("left"):
		Body.apply_central_impulse(-BodyControl.transform.basis.x*WalkSpeed)
		IsWalking = true
	if Input.is_action_pressed("right"):
		Body.apply_central_impulse(BodyControl.transform.basis.x*WalkSpeed)
		IsWalking = true
	if Input.is_action_pressed("backward"):
		Body.apply_central_impulse(BodyControl.transform.basis.z*WalkSpeed)
		IsWalking = true

	if Input.is_action_just_pressed("jump"):
		if CanJump == true:
			if JumpRayCast.is_colliding():
				if JumpRayCast.get_collision_normal().y > 0.5:
					CanJump = false
					Body.apply_central_impulse(BodyControl.transform.basis.y*JumpStrength)
					yield(get_tree().create_timer(0.25), "timeout")
					CanJump = true


	if IsWalking:
		AnimateWalk()
	else:
		LeftLegControl.rotation.x = 0
		RightLegControl.rotation.x = 0

func AnimateWalk():
	WalkAnimationTimer += 0.1
	LeftLegControl.rotation.x = sin(WalkAnimationTimer)*2
	RightLegControl.rotation.x = -sin(WalkAnimationTimer)*2

func _input(event):
	if Input.is_action_just_pressed("left_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion:
		CameraPivot.rotation_degrees.y -= event.relative.x * Mouse_sensitivity
		CameraPivot.rotation_degrees.x -= event.relative.y * Mouse_sensitivity
		CameraPivot.rotation_degrees.x = clamp(CameraPivot.rotation_degrees.x, -90, 90)








func _on_RightHand_body_entered(b):
	if RightHandActive:
		if b.is_in_group("CanGrab"):
			if RightHandGrab == null:
				RightGrabJoint.set_node_a(RightArm3.get_path())
				RightGrabJoint.set_node_b(b.get_path())
				RightHandGrab = b


func _on_LeftHand_body_entered(b):
	if LeftHandActive:
		if b.is_in_group("CanGrab"):
			if LeftHandGrab == null:
				LeftGrabJoint.set_node_a(LeftArm3.get_path())
				LeftGrabJoint.set_node_b(b.get_path())
				LeftHandGrab = b
