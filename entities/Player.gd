extends KinematicBody2D

class_name Player

func _init() -> void:
	var collision_shape := CollisionShape2D.new();
	var shape := RectangleShape2D.new();
	shape.set_extents(Vector2(16, 16));
	collision_shape.set_shape(shape);
	add_child(collision_shape);
