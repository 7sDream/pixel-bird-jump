extends Node2D

# ===== Override =====

func _ready():
    # let the pipe generated at right of the screen
    $MovingPipes.position.x = get_viewport().get_visible_rect().size.x
    
    start()

# ===== Function =====
    
func start():
    # calcel pasue
    get_tree().paused = false
    
    # reset bird
    $Bird.start($StartPosition.position)
    
    # start pipes after a few second, let player to suit the game
    $MovingPipes.start(1500)
    
    # make HUD to whoe start message
    $GameHUD.game_start()
    
    # stop the fail audio when restart
    $FailAudio.stop()
    
    # player the bgm
    $BGM.play()

# ===== Signal Process ======

# onec the bird hit something, it die, user can't control it anymore
func _on_Bird_hit():
    $Bird.dead()

func _on_GameHUD_restart_clicked():
    $Pause.go_on()
    start()

func _on_GameHUD_exit_clicked():
    $Pause.go_on()
    get_tree().change_scene("res://scenes/Title/Title.tscn")

# when bird out the bottom of screen, show game over, play audio and stop bgm
func _on_Bird_sleeped():
    $GameHUD.game_over()
    $FailAudio.play()
    $BGM.stop()

# once pipe meet the line, it gives this signal, just add 10 score to HUD and play a coin SE
func _on_MovingPipes_new_score():
    if $Bird.alive:
        $GameHUD.add_score(10, 500)
        $ScoreAudio.play()
