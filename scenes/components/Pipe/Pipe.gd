extends StaticBody2D

# ===== Export =====

# the head height is fixed
export (int) var BASE_HEAD_HEIGHT = 50

# ====== Member ======

onready var head_texture_size = $Head.texture.get_size()
onready var tail_texture_size = $Tail.texture.get_size()

var size setget set_size, get_size

# ====== Function =====

func set_size(wh):
    # meke head to fit the giving width, but height is fixed
    var head_size = $SizeUtil.scale_full_screen($Head, $Head.texture, Vector2(wh.x, BASE_HEAD_HEIGHT))
    # make tail fit the giving width, and height equals giving height - fixed head height
    var tail_size = $SizeUtil.scale_full_screen($Tail, $Tail.texture, Vector2(wh.x, wh.y - BASE_HEAD_HEIGHT))
    
    # move the collision shape of two part
    
    $HeadCollisionShape2D.position.y = head_size.y / 2
    # shape must be duplicate before modify, otherwise the shape of all instance will be modified
    var new_head_shape = $HeadCollisionShape2D.shape.duplicate()
    new_head_shape.extents = Vector2(head_size.x / 2, head_size.y / 2)
    $HeadCollisionShape2D.shape = new_head_shape
    
    $Tail.position.y = BASE_HEAD_HEIGHT
    $TailCollisionShape2D.position.y = $Tail.position.y + tail_size.y / 2
    var new_tail_shape = $TailCollisionShape2D.shape.duplicate()
    new_tail_shape.extents = Vector2(tail_size.x / 2 * 0.75, tail_size.y / 2)
    $TailCollisionShape2D.shape = new_tail_shape
    
    size = wh

func get_size():
    return size

# ===== Signal Process =====

# auto remove itself after leave screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
