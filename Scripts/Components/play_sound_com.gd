extends Node

class_name PlaySoundCom

func handle_play_sound(stream: AudioStream, query: bool) -> void:
	if (query):
		EventsBus.play_sound_request.emit(stream)
