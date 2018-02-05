extends Node2D

# ===== Export =====

# Background move basespeed
export (int) var BG_SPEED = 200

# interval for generate a house
export (float) var HOUSE_HEIGHT_PRESENT = 0.2
export (int) var HOUSE_GEN_INTERVAL = 5000

# interval for generate a cloud
export (int) var CLOUD_GEN_INTERVAL = 5000
export (float) var CLOUD_HEIGHT_PRESENT = 0.1
export (int) var CLOUD_BASE_SPEED = 30
export (int) var CLOUD_MAX_ADD_SPEED = 170
export (float) var CLOUD_GEN_REGION_MIN_PERSENT = 0.1
export (float) var CLOUD_GEN_REGION_MAX_PERSENT = 0.4

# ===== Member =====

onready var screen_size = get_viewport_rect().size

# cloud generate region
onready var cloud_region = [int(screen_size.y * CLOUD_GEN_REGION_MIN_PERSENT), int(screen_size.y * CLOUD_GEN_REGION_MAX_PERSENT)]

# templates for create house and cloud
onready var house_templates = $House.get_children()
onready var cloud_templates = $Cloud.get_children()

# background move speed factor for levels 1 - 6 
const LEVEL_SPEED_ARRAY = [0.1, 0.19, 0.34, 0.52, 0.74, 1]

# ===== Override =====

func _ready():
    # background to full screen
    $ColorRect.rect_size = screen_size
    
    # scale way to fit screen width
    var texture = $Way/AnimatedSprite.frames.get_frame("default", 0)
    var way_size = $SizeUtil.scale_fit_width($Way/AnimatedSprite, texture, screen_size)
    
    # move Background and House just above the way
    $BG.position.y = screen_size.y - way_size.y
    $House.position.y = screen_size.y - way_size.y
    
    # scale all background image to fit screen
    for node in get_tree().get_nodes_in_group("Level"):
        $SizeUtil.scale_full_screen(node, node.texture, screen_size)
        node.set_meta("old", false)
    
    # scale all house node to fit screen width with factor
    for house in house_templates:
        $SizeUtil.scale_fit_height(house, house.texture, screen_size * HOUSE_HEIGHT_PRESENT)
    
    # scale all cloud node to fit screen width with factor
    for cloud in cloud_templates:
        $SizeUtil.scale_fit_height(cloud, cloud.texture, screen_size * CLOUD_HEIGHT_PRESENT)
    
    randomize()

func _process(delta):
    # iter all level
    for level in range(1, 7):
        for node in get_tree().get_nodes_in_group("L" + str(level)):
            
            # move it, speed based on level, the farther we go, the slower things move
            node.position.x -= delta * BG_SPEED * LEVEL_SPEED_ARRAY[level - 1]
            
            # first time when thie node hit left screen
            if node.position.x <= 0 and !node.get_meta("old"):
                node.set_meta("old", true)
                
                # create a new node
                var new_node = node.duplicate()
                new_node.set_meta("old", false)
                node.get_parent().add_child(new_node)
                
                # put after it to make a infinite background
                new_node.position.x = screen_size.x + node.position.x
            
            # the whole node is out screen, delete it
            if node.position.x <= - screen_size.x:
                node.queue_free()

    # move houses
    for house in get_tree().get_nodes_in_group("House"):
        house.position.x -= BG_SPEED * delta
        
        # the whole node is out screen, delete it
        var house_size = $SizeUtil.get_sprite_size(house)
        if house.position.x <= - house_size.x:
            house.queue_free()

    # move clouds
    for cloud in get_tree().get_nodes_in_group("Cloud"):
        # every cloud has its speed
        cloud.position.x -= cloud.get_meta("speed") * delta
        
        # the whole node is out screen, delete it
        var cloud_size = $SizeUtil.get_sprite_size(cloud)
        if cloud.position.x <= - cloud_size.x:
            cloud.queue_free()

# ===== Function =====

func add_house():
    # create new house
    var house = __random_create_from_templates(house_templates, $House, "House")
    # move house to screen right
    var house_size = $SizeUtil.get_sprite_size(house)
    house.position.x = screen_size.x + house_size.x
    # show it
    house.show()

func add_cloud():
    # create new cloud
    var cloud = __random_create_from_templates(cloud_templates, $Cloud, "Cloud")
    # move cloud to screen right
    var cloud_size = $SizeUtil.get_sprite_size(cloud)
    cloud.position.x = screen_size.x + cloud_size.x
    # move cloud to it's region
    cloud.position.y = cloud_region[0] + (randi() % (cloud_region[1] - cloud_region[0]))
    # cloud speed randomize
    cloud.set_meta("speed", CLOUD_BASE_SPEED + randi() % CLOUD_MAX_ADD_SPEED)
    # show it
    cloud.show()

func __random_create_from_templates(templates, parent=null, group=null):
    # random choose a template
    var template = templates[randi() % templates.size()]
    # create new node
    var new_node = template.duplicate()
    # add to tree
    if parent != null:
        parent.add_child(new_node)
    # add group
    if group != null:
        new_node.add_to_group(group)
    return new_node

# ===== Signal Process =====

func _on_HouseGenTimer_timeout():
    # create a house
    add_house()
    # start next generate timer
    var next_timeout = randi() % HOUSE_GEN_INTERVAL
    $HouseGenTimer.wait_time = next_timeout / 1000.0
    $HouseGenTimer.start()

func _on_CloudGenTimer_timeout():
    # create a house
    add_cloud()
    # start next generate timer
    var next_timeout = randi() % CLOUD_GEN_INTERVAL
    $CloudGenTimer.wait_time = next_timeout / 1000.0
    $CloudGenTimer.start()
