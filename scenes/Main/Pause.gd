extends Node2D

onready var root = get_tree().get_root().get_child(0)
onready var game_hud = get_tree().get_root().get_node("Main/GameHUD")
onready var bird = get_tree().get_root().get_node("Main/Bird")

var __waiting = false
var sec = 0

func _input(event):
    if !bird.alive or __waiting:
        return

    if event.is_action_pressed("pause"):
        if get_tree().paused:
            game_hud.go_on()
            sec = 3
            game_hud.show_message(str(sec), 1000)
            $Timer.wait_time = 1
            $Timer.start()
            __waiting = true
        else:
            pause()

func pause():
    get_tree().paused = true
    root.modulate = Color(0.6, 0.6, 0.6, 1)
    game_hud.pause()

func go_on():
    get_tree().paused = false
    root.modulate = Color(1, 1, 1, 1)
    game_hud.go_on()
    __waiting = false

func _on_Timer_timeout():
    sec -= 1
    if sec == 0:
        go_on()
    else:
        game_hud.show_message(str(sec), 1000)
        $Timer.wait_time = 1
        $Timer.start()
