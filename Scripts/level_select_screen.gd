extends Screen

class_name LevelSelectScreen

@onready var one_one_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer/OneOneLabel
@onready var one_two_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer/OneTwoLabel
@onready var one_three_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer/OneThreeLabel
@onready var two_one_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer2/TwoOneLabel
@onready var two_two_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer2/TwoTwoLabel
@onready var two_three_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer2/TwoThreeLabel
@onready var three_one_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer3/ThreeOneLabel
@onready var three_two_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer3/ThreeTwoLabel
@onready var three_three_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer3/ThreeThreeLabel
@onready var four_one_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer4/FourOneLabel
@onready var four_two_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer4/FourTwoLabel
@onready var four_three_label: Label = $CanvasLayer/VBoxContainer/HBoxContainer4/FourThreeLabel
@onready var back_label: Label = $CanvasLayer/VBoxContainer/BackLabel

@onready var all_labels: Array[Array] = [[one_one_label, one_two_label, one_three_label],
											[two_one_label, two_two_label, two_three_label],
											[three_one_label, three_two_label, three_three_label],
											[four_one_label, four_two_label, four_three_label],
											[back_label]]

var world_num: int = 0
var level_num: int = 0

var old_world_num: int = 0
var old_level_num: int = 0

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("up")):
		old_world_num = world_num
		old_level_num = level_num
		world_num -= 1
		
		if (world_num < 0):
			world_num = len(all_labels) - 1
		elif (world_num >= len(all_labels)):
			world_num = 0
		
		if (level_num < 0):
			level_num = len(all_labels[world_num]) - 1
		elif (level_num >= len(all_labels[world_num])):
			level_num = 0
		
		set_unselected(all_labels[old_world_num][old_level_num])
		set_selected(all_labels[world_num][level_num])
	elif (Input.is_action_just_pressed("down")):
		old_world_num = world_num
		old_level_num = level_num
		world_num += 1
		
		if (world_num < 0):
			world_num = len(all_labels) - 1
		elif (world_num >= len(all_labels)):
			world_num = 0
		
		if (level_num < 0):
			level_num = len(all_labels[world_num]) - 1
		elif (level_num >= len(all_labels[world_num])):
			level_num = 0
		
		set_unselected(all_labels[old_world_num][old_level_num])
		set_selected(all_labels[world_num][level_num])
	elif (Input.is_action_just_pressed("left")):
		old_world_num = world_num
		old_level_num = level_num
		level_num += 1
		
		if (world_num < 0):
			world_num = len(all_labels) - 1
		elif (world_num >= len(all_labels)):
			world_num = 0
		
		if (level_num < 0):
			level_num = len(all_labels[world_num]) - 1
		elif (level_num >= len(all_labels[world_num])):
			level_num = 0
		
		set_unselected(all_labels[old_world_num][old_level_num])
		set_selected(all_labels[world_num][level_num])
	elif (Input.is_action_just_pressed("right")):
		old_world_num = world_num
		old_level_num = level_num
		level_num -= 1
		
		if (world_num < 0):
			world_num = len(all_labels) - 1
		elif (world_num >= len(all_labels)):
			world_num = 0
		
		if (level_num < 0):
			level_num = len(all_labels[world_num]) - 1
		elif (level_num >= len(all_labels[world_num])):
			level_num = 0
		
		set_unselected(all_labels[old_world_num][old_level_num])
		set_selected(all_labels[world_num][level_num])
	
	if (Input.is_action_just_pressed("jump")):
		match world_num:
			0:
				load_transition_request.emit("%s-%s" % [world_num + 1, level_num + 1], "THE LOBBY", "world_%s_level_%s" % [world_num + 1, level_num + 1])
			1:
				load_transition_request.emit("%s-%s" % [world_num + 1, level_num + 1], "THE POOLROOMS", "world_%s_level_%s" % [world_num + 1, level_num + 1])
			2:
				load_transition_request.emit("%s-%s" % [world_num + 1, level_num + 1], "THE NEIGHBORHOOD", "world_%s_level_%s" % [world_num + 1, level_num + 1])
			3:
				load_transition_request.emit("%s-%s" % [world_num + 1, level_num + 1], "THE END", "world_%s_level_%s" % [world_num + 1, level_num + 1])
			4:
				load_screen_request.emit("title_screen")

func set_selected(my_label: Label) -> void:
	my_label.set("theme_override_colors/font_color", Color.WHITE)
	var new_text: String = ">%s" % my_label.text
	my_label.text = new_text

func set_unselected(my_label: Label) -> void:
	my_label.set("theme_override_colors/font_color", Color(0.333, 0.333, 0.333, 1.0))
	my_label.text = my_label.text.substr(1)
