extends Node2D

# ===== Signal =====

signal new_score

# ===== Export =====

# size of pipes
export (int) var HEAD_HEIGHT = 50
export (int) var WIDTH = 120

# appear location
export (int) var MIN_SPACE_Y = 100
export (int) var MAX_SPACE_Y = 620
export (int) var MARGIN_BOTTOM = 35

# pixel interval between pipes
export (int) var INTERVAL = 300

# space between up and down pipe
export (int) var SPACE = 180

# pipe moving speed
export (int) var SPEED = 300

# signal point
export (int) var TRIGGER_DISTANCE = 380

# ===== Member =====

# pile template
var Pipe = preload("res://scenes/components/Pipe/Pipe.tscn").instance()

# switch
var enable = false

onready var window_height = get_viewport().get_visible_rect().size.y

# ===== Override =====

func _ready():
    randomize()

func _process(delta):
    if !enable:
        return
    
    # make pipe run
    for pipe in get_tree().get_nodes_in_group("Pipe"):
        pipe.position.x -= delta * SPEED
        
        # if pipe meet the line, make a new pipe, use meta make this just happen once per pipe
        if pipe.position.x <= -INTERVAL and !pipe.get_meta("old"):
            pipe.set_meta("old", true)
            __create_pipe()
            
        # if pipe meet the player(TRIGGER_DISTANCE), send signal, use meta make this just happen once per pipe
        if pipe.position.x <= -TRIGGER_DISTANCE and !pipe.get_meta("send_signal"):
            emit_signal("new_score")
            pipe.set_meta("send_signal", true)

# ===== Function =====

func start(waiting=0):
    __clean_pipes()
    
    if waiting == 0:
        enable = true
    else: # waiting some times before enable pipe generation
        enable = false
        $WaitingTimer.wait_time = waiting / 1000.0
        $WaitingTimer.start()

# ===== Inner ======

func __create_pipe():
    # Copy two new pipe and set property
    var upPipe = Pipe.duplicate()
    var downPipe = Pipe.duplicate()
    upPipe.BASE_HEAD_HEIGHT = HEAD_HEIGHT
    downPipe.BASE_HEAD_HEIGHT = HEAD_HEIGHT
    upPipe.add_to_group("Pipe")
    downPipe.add_to_group("Pipe")
    
    # two pipe as a group, juse let one of them to be processed in _process function
    upPipe.set_meta("old", false)
    upPipe.set_meta("send_signal", false)
    downPipe.set_meta("old", true)
    downPipe.set_meta("send_signal", true)
    
    # add to tree
    add_child(upPipe)
    add_child(downPipe)
    
    # space location
    var y = int(rand_range(MIN_SPACE_Y, MAX_SPACE_Y - SPACE))
    
    # adjust pipe size based on space location
    upPipe.size = Vector2(WIDTH, y)
    downPipe.size = Vector2(WIDTH, window_height  - MARGIN_BOTTOM - y - SPACE)
    
    # move them to the location based on space
    upPipe.position = Vector2(WIDTH, y)
    downPipe.position = Vector2(WIDTH, y + SPACE)
    
    # rotate up pipe 180 degree
    # the pivot of pipe is up center, so the rotation will keep the space betweem two pipe 
    upPipe.scale.y = -1

# delete all pipes
func __clean_pipes():
    for pipe in get_tree().get_nodes_in_group("Pipe"):
        pipe.queue_free()

# ===== Signal Process =====

# waiting some times before enable pipe generation
func _on_WaitingTimer_timeout():
    __create_pipe()
    enable = true
