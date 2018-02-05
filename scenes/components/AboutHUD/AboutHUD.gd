extends CanvasLayer

# ===== Signal =====

# when press back key
signal back_pressed

# ===== Export =====

# text up down speed of keyboard
export (int) var KEYBOARD_SPEED = 100

# text up down speed of mouse scroll 
export (int) var MOUSE_SCROLL_SPEED = 20

# ===== Member =====

# scroll bar of rich text
onready var scroll = $MarginContainer/VBoxContainer/RichTextLabel.get_v_scroll()

# ===== Override =====

func _ready():
    # make bird at horizontal center
    $Bird.start($MarginContainer/VBoxContainer/Container.rect_size / 2.0 + Vector2(20, 20))
    # bild dont move, as a image
    $Bird.dead()

func _process(delta):
    # move text up and down by key
    if Input.is_action_pressed("ui_down") or Input.is_action_pressed("jump"):
        # mouse left button don't make text up
        if !Input.is_mouse_button_pressed(BUTTON_LEFT):
            scroll.value += delta * KEYBOARD_SPEED
    if Input.is_action_pressed("ui_up"):
        scroll.value -= delta * KEYBOARD_SPEED

func _input(event):
    if event.is_action("scroll_down"):
        scroll.value += MOUSE_SCROLL_SPEED
    elif event.is_action("scroll_up"):
        scroll.value -= MOUSE_SCROLL_SPEED
    elif event.is_action("ui_cancel"):
        emit_signal("back_pressed")

# ===== Signal Process =====

# when links in rich text be clicked, open it in browser
func _on_RichTextLabel_meta_clicked( meta ):
    OS.shell_open(meta)

func _on_Back_pressed():
    emit_signal("back_pressed")
    