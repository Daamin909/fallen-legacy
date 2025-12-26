extends Node

@export var is_player_position_inside_home_right = true
@export var graveyard_done = true
@export var post_arkblade_done = false
var cached_scenes := {}



func preload_scene(path: String, async: bool = false) -> void:
	if cached_scenes.has(path):
		return

	if async:
		var res = await _load_async(path)
		cached_scenes[path] = res
	else:
		cached_scenes[path] = ResourceLoader.load(path)


func change_scene(path: String) -> void:
	var packed: PackedScene

	if cached_scenes.has(path):
		packed = cached_scenes[path]
	else:
		packed = ResourceLoader.load(path)
		cached_scenes[path] = packed

	get_tree().change_scene_to_packed(packed)


func _load_async(path: String):
	var err = ResourceLoader.load_threaded_request(path)
	if err != OK:
		push_error("Failed to start threaded load: " + path)
		return null

	while true:
		var status = ResourceLoader.load_threaded_get_status(path)

		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			await get_tree().process_frame

		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			return ResourceLoader.load_threaded_get(path)

		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Threaded load FAILED: " + path)
			return null

		else:
			push_error("Unknown threaded load state for: " + path)
			return null
