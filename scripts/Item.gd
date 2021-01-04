extends KinematicBody2D
export var gravity := 500.0 #export

const _SNAP_DISTANCE := 2.0
const _MAX_SLIDES := 5
const _MAX_SLOPE_ANGLE := 0.25 * PI

var _velocity := Vector2.ZERO
var held := false #underscore?

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if !.is_on_floor() and !held:
		self._velocity.y += self.gravity * delta
	
	var snap := self._SNAP_DISTANCE * Vector2.DOWN
	self._velocity = .move_and_slide_with_snap(self._velocity, snap, Vector2.UP, false, self._MAX_SLIDES, self._MAX_SLOPE_ANGLE, true);
