extends KinematicBody2D

export var gravity := 300.0
export var walk_speed := 300.0

const _SNAP_DISTANCE := 2.0
const _MAX_SLIDES := 5
const _MAX_SLOPE_ANGLE := 0.25 * PI

var _velocity := Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if !.is_on_floor():
		self._velocity += self.gravity * delta * Vector2.DOWN
	var snap := self._SNAP_DISTANCE * Vector2.DOWN
	self._velocity = .move_and_slide_with_snap(self._velocity, snap, Vector2.UP, false, self._MAX_SLIDES, self._MAX_SLOPE_ANGLE, true);
	
