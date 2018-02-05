extends Node2D

# ===== Fcuntion =====
static func scale_full_screen(node, texture, screen_size):
    var texture_size = texture.get_size()
    var scale_width = float(screen_size.x) / texture_size.x
    var scale_height = float(screen_size.y) / texture_size.y
    node.scale = Vector2(scale_width, scale_height)
    return Vector2(texture_size.x * scale_width, texture_size.y * scale_height)

static func scale_fit_width(node, texture, screen_size):
    var texture_size = texture.get_size()
    var scale_width = float(screen_size.x) / texture_size.x
    var scale_height = scale_width
    node.scale = Vector2(scale_width, scale_height)
    return Vector2(texture_size.x * scale_width, texture_size.y * scale_height)

static func scale_fit_height(node, texture, screen_size):
    var texture_size = texture.get_size()
    var scale_height = float(screen_size.y) / texture_size.y
    var scale_width = scale_height
    node.scale = Vector2(scale_width, scale_height)
    return Vector2(texture_size.x * scale_width, texture_size.y * scale_height)

static func get_sprite_size(sprite):
    var texture_size = sprite.texture.get_size()
    var scale = sprite.scale
    return Vector2(texture_size.x * scale.x, texture_size.y * scale.y)
