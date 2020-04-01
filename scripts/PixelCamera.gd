extends Camera2D

onready var _tree := .get_tree()
onready var _viewport := .get_viewport()
onready var _base_size := self._viewport.size

func _ready() -> void:
	if self._tree.connect("screen_resized", self, "_screen_resized") != OK:
		printerr("PixelCamera couldn't connect to screen resize signal")
	self._viewport.set_attach_to_screen_rect(self._viewport.get_visible_rect())
	self._screen_resized()

func _screen_resized() -> void:
	var window_size := OS.window_size
	var scale_x := max(int(window_size.x / self._base_size.x), 1)
	var scale_y := max(int(window_size.y / self._base_size.y), 1)
	var scale_factor := min(scale_x, scale_y)
	var upper_left := (0.5 * (window_size - scale_factor * self._viewport.size)).floor()
	self._viewport.set_attach_to_screen_rect(Rect2(upper_left, scale_factor * self._viewport.size))
	
	# Black bars to prevent flickering.
	var odd_offset := Vector2(int(window_size.x) % 2, int(window_size.y) % 2)
	VisualServer.black_bars_set_margins(
		int(max(upper_left.x, 0)),
		int(max(upper_left.y, 0)),
		int(max(upper_left.x, 0) + odd_offset.x),
		int(max(upper_left.y, 0) + odd_offset.y))
