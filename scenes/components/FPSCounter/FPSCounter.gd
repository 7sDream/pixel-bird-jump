extends Label

# ===== Export =====

export (int) var frequency = 1

# ===== Member =====

var frame_count = 0
var time_elapse = 0
var max_time_elapse = 1.0 / frequency

# ===== Override =====

func _process(delta):
    time_elapse += delta
    frame_count += 1
    if time_elapse >= max_time_elapse:
        text = str(int(frame_count * frequency))
        frame_count = 0
        time_elapse = 0
