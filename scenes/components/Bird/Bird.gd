extends RigidBody2D

# ===== Export =====

# Init horizontal speed
export (int) var INIT_SPEED = 500
# Jump give vertical speed
export (int) var JUMP_SPEED = 450

# ===== Signal =====

# when bird hit something or out the scren, send this signal
signal hit
# when bild out the screen bottom, send this signal
signal sleeped

# ===== Member =====

onready var screen_height = get_viewport_rect().size.y
onready var bird_height = $AnimatedSprite.frames.get_frame("default", 0).get_size().y * $AnimatedSprite.scale.y 

# base rotation
onready var sprite_base_rotation = $AnimatedSprite.rotation
onready var collision_base_rotation = $CollisionShape2D.rotation

# is the bird alive
var alive = true

# move the bird to this pos in next physics time
var __pos = null

# ===== Override =====

func _process(delta):
    # make sure physics time adjust position finish
    if __pos != null:
        __pos = null
        return
    
    # rotation based on velocity direction
    var velocity = linear_velocity
    # add the fake horizontal velocity
    velocity.x = INIT_SPEED
    # calc the degree
    var rotation = - velocity.angle_to(Vector2(1, 0))
    # rotate the sprite and collision area
    $AnimatedSprite.rotation = rotation + sprite_base_rotation
    $CollisionShape2D.rotation = rotation + collision_base_rotation
    
    # If hit the top or bottom, as hit something
    if alive and (position.y < - bird_height or position.y > screen_height + bird_height):
        if __pos == null:
            __hit()
    # if fall to botom, stop process physics and frame, send signal
    if !sleeping and position.y > screen_height + bird_height:
        sleeping = true
        set_process(false)
        emit_signal("sleeped")

func _input(event):
    if alive and event.is_action_pressed("jump"):
        # add a up velocity and play audio
        set_axis_velocity(Vector2(0, -JUMP_SPEED))
        $JumpAudio.play()

# reset bird that in physics process gap
func _integrate_forces(state):
    if __pos != null:
        # clean velocity
        state.linear_velocity = Vector2(0, 0)
        state.angular_velocity = 0
        # rotate back and move to position
        var xform = transform
        xform = xform.rotated(-xform.get_rotation())
        xform.origin = __pos
        # do the transform
        state.transform = xform
        # make bird live again
        set_process(true)
        set_process_input(true)

# ===== Fucntion =====

func start(pos):
    alive = true
    # let physics come back
    sleeping = false
    
    # this will make _integrate_forces function run and make bird to __pos in next physics process gap
    __pos = pos

func dead():
    alive = false
    set_process_input(false)

# ===== Inner =====

# collision with something, 
func __hit():
    if alive:
        emit_signal("hit")
    $CollisionAudio.play()

func _on_Bird_body_entered(body):
    __hit()
