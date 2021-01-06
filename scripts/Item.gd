extends KinematicBody2D
export var gravity := 500.0 #export

const _SNAP_DISTANCE := 2.0
const _MAX_SLIDES := 5
const _MAX_SLOPE_ANGLE := 0.25 * PI

export var type := ""
export var can_pick_up := true #if an item can be picked up

var _velocity := Vector2.ZERO
var held := false #underscore?

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if !.is_on_floor() and !held:
		self._velocity.y += self.gravity * delta
	if self._velocity.x > 0.75:
		self._velocity.x -= 0.75
	elif self._velocity.x < 0.75:
		self._velocity.x += 0.75
	else:
		self._velocity.x = 0
	var snap := self._SNAP_DISTANCE * Vector2.DOWN
	self._velocity = .move_and_slide_with_snap(self._velocity, snap, Vector2.UP, false, self._MAX_SLIDES, self._MAX_SLOPE_ANGLE, true);

func use_item(direction):
	_throw_item(direction)
	
func _throw_item(direction):
	if direction == "left":
		self._velocity.x -= 100
	elif direction == "right":
		self._velocity.x += 100
	self._velocity.y -= 200
