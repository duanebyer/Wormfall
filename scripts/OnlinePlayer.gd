extends KinematicBody2D

const Item := preload("res://scripts/Item.gd")
const Door := preload("res://scripts/Door.gd")

export var gravity := 500.0
export var walk_speed := 150.0
export var jump_speed := 200.0

const _SNAP_DISTANCE := 2.0
const _MAX_SLIDES := 5
const _MAX_SLOPE_ANGLE := 0.25 * PI

var _velocity := Vector2.ZERO

onready var _area := $Area2D
onready var _hand := $Hand
var _held_item : Item = null
var _held_item_parent : Node2D = null


puppet func setPosition(pos):
	position = pos
	
master func shutItDown():
	#Send a shutdown command to all connected clients, including this one
	rpc("shutDown")
	
sync func shutDown():
	get_tree().quit()

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if (is_network_master()):
		if !.is_on_floor():
			self._velocity.y += self.gravity * delta
		else:
			if Input.is_action_just_pressed("jump"):
				self._velocity.y = -self.jump_speed

		var move_dir := 0
		if Input.is_action_pressed("walk_left"):
			move_dir -= 1
		if Input.is_action_pressed("walk_right"):
			move_dir += 1
		self._velocity.x = move_dir * self.walk_speed

		var snap := self._SNAP_DISTANCE * Vector2.DOWN
		self._velocity = self.move_and_slide_with_snap(self._velocity, snap, Vector2.UP, false, self._MAX_SLIDES, self._MAX_SLOPE_ANGLE, true);
		
		#Tell the other computer about our new position so it can update
		#id as first argument if you only want to communicate to one computer
		rpc_unreliable("setPosition", position)

func _process(_delta : float) -> void:
	if (is_network_master()):
		if Input.is_action_just_pressed("interact"):
			if _held_item == null: #picking up an item
				var collision_areas : Array = _area.get_overlapping_areas()
				var indices = collision_indices(collision_areas)
				if indices.x >= 0:
					_pick_up_item(collision_areas[indices.x].get_parent())
				elif indices.y >= 0:
					_enter_door(collision_areas[indices.y].get_parent())
			else: #dropping an item
				_drop_item()
		if Input.is_action_just_pressed("quit"):
			if is_network_master():
					shutItDown()
		

#think of a better way to do this prolly
func collision_indices(collision_areas) -> Vector2:
	var output = Vector2(-1, -1)
	for i in collision_areas.size():
		var collision : Node2D = collision_areas[i].get_parent()
		if collision is Item:
			output.x = i
		elif collision is Door:
			output.y = i
		if output.x >= 0 and output.y >= 0:
			break
	return output

func _pick_up_item(item) -> void:
	_held_item = item
	_held_item.held = true
	_held_item_parent = item.get_parent()
	item.get_parent().remove_child(_held_item)
	_hand.add_child(_held_item)
	_held_item.position = Vector2.ZERO
	_held_item._velocity = Vector2.ZERO

func _drop_item() -> void:
	var held_item_pos := _held_item.global_position
	_held_item.held = false
	_hand.remove_child(_held_item)
	_held_item_parent.add_child(_held_item)
	_held_item.global_position = held_item_pos
	_held_item = null
	_held_item_parent = null

func _enter_door(door):
	get_tree().change_scene_to(door.leads_to)

