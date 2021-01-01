extends KinematicBody2D
const Item := preload("res://scripts/Item.gd")

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

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
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
	self._velocity = .move_and_slide_with_snap(self._velocity, snap, Vector2.UP, false, self._MAX_SLIDES, self._MAX_SLOPE_ANGLE, true);
	

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("interact"):
		if _held_item == null:
			var item_areas : Array = _area.get_overlapping_areas()
			for item_area in item_areas:
				var item : Node2D = item_area.get_parent()
				if item is Item:
					_held_item = item
					_held_item_parent = item.get_parent()
					item.get_parent().remove_child(_held_item)
					_hand.add_child(_held_item)
					_held_item.position = Vector2.ZERO
					break
		else:
			var held_item_pos := _held_item.global_position
			_hand.remove_child(_held_item)
			_held_item_parent.add_child(_held_item)
			_held_item.global_position = held_item_pos
			_held_item = null
			_held_item_parent = null
