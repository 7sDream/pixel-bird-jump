extends CanvasLayer

# ===== Signal =====

signal restart_clicked
signal exit_clicked

# ===== Member =====

var score = 0

func _ready():
    set_process_input(true)

# ===== Function =====

func game_start(text="Ready!", ready_timeout=1500, score_timeout=300):
    show_message(text, ready_timeout)
    update_score(0, score_timeout)
    $Menu.hide()
    $Message/Board.hide()

func game_over(text="Game\nOver", color=Color(0x683611ff)):
    show_message(text, 0, color)
    $Message/Board.show()
    $Menu.show()
    $Menu/Restart.grab_focus()
    
func pause(pause_text="Pasue"):
    show_message(pause_text)
    $Menu.show()
    $Menu/Restart.grab_focus()

func go_on():
    hide_message()
    $Menu.hide()

func show_message(text, timeout=0, color=Color(1, 1, 1, 1)):
    $Message/Message.text = text
    $Message/Message.add_color_override("font_color", color)
    $Message.show()
    
    # message auto hide after timeout use timer
    if timeout > 0:
        $MessageTimer.stop()
        $MessageTimer.wait_time = timeout / 1000.0
        $MessageTimer.start()
    else:
        $MessageTimer.stop()

func hide_message():
    $Message.hide()

func add_score(value, duration=800):
    update_score(score + value, duration)

# update score with animation
func update_score(new_score, duration=0):
    score = new_score
    
    # duration = 0 means no animiton
    if duration == 0:
        __update_score_to_label(new_score)
        return
    
    # get current score in animation
    var current_score = int($Score.text)
    # last animation don't finish, get time needed from start
    var end_time = $Tween.get_runtime()
    var time_left = end_time - $Tween.tell()
    # stop last animation
    $Tween.stop_all()
    
    # start new animation
    $Tween.interpolate_method(
            self, "__update_score_to_label", 
            current_score, new_score, 
            # new animation durtaion = last animation time left + this animation duration
            time_left + duration / 1000.0, 
            Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    
func __update_score_to_label(score):
    $Score.text = str(int(score))

# ===== Signal Process =====

func _on_MessageTimer_timeout():
    $Message.hide()

func _on_Restart_pressed():
    emit_signal("restart_clicked")

func _on_Exit_pressed():
    emit_signal("exit_clicked")

# menu select SE
func _on_focus_changed():
    $MenuAudio.play()
