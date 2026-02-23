extends AudioStreamPlayer

@onready
var base_vol = volume_db
@onready
var base_pitch = pitch_scale

func play_randomized():
	volume_db = base_vol+randf_range(-1,1)
	pitch_scale = base_pitch*randf_range(.8,1.2)
	play()
