extends Node

var cached_scenes := {}

var is_player_position_inside_home_right = true

func preload_scene(path: String):
	if not cached_scenes.has(path):
		cached_scenes[path] = load(path)

func change_scene(path: String):
	var packed: PackedScene

	if cached_scenes.has(path):
		packed = cached_scenes[path]
	else:
		packed = load(path)
		cached_scenes[path] = packed
	get_tree().change_scene_to_packed(packed)
