extends CanvasLayer

# ===== Signal Process =====

func _on_TitleHUD_start_clicked():
    get_tree().change_scene("res://scenes/Main/Main.tscn")

func _on_TitleHUD_exit_clicked():
    get_tree().quit()

func _on_TitleHUD_about_clicked():
    get_tree().change_scene("res://scenes/About/About.tscn")
