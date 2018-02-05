extends CanvasLayer

# ===== Signal ======

# some signal when button clicked
signal start_clicked
signal about_clicked
signal exit_clicked

# ===== Member =====

var __grab = true

# ===== Override =====

func _ready():
    $Menu/Start.grab_focus()
    __grab = false

# ===== Singal Process =====

func _on_Start_pressed():
    emit_signal("start_clicked")

func _on_Exit_pressed():
    emit_signal("exit_clicked")

func _on_About_pressed():
    emit_signal("about_clicked")

func _on_focus_changed_entered():
    if !__grab:
        $MenuAudio.play()

