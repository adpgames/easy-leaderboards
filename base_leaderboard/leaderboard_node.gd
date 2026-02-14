# Optional, add to execute in the editor.
@tool

# Icons are optional.
# Alternatively, you may use the UID of the icon or the absolute path.
@icon("res://addons/Easy_Leaderboards/base_leaderboard/Trophy.png")

# Automatically register the node in the Create New Node dialog
# and make it available for use with other scripts.
class_name BaseLeaderboard
extends Panel

## Theme to use in the leaderboard.
@export var leaderboard_theme : Theme = preload("res://addons/Easy_Leaderboards/Demo/demo_theme.tres")

## The name of the leaderboard to be displayed.
@export var leaderboard_name := "Demo Leaderboard"

## The headers to display at top of leaderboard.
@export var headers : Array = ["Placement", "Name", "Score"]

## The color behind the name and headers of the leaderboard.
@export var head_color := Color(0.0, 0.525, 1.0, 1.0)

## Array that contains scores to display on the leaderboard. Scores should be dictionaries with keys for each header. 
@export var scores : Array

## The max amount of scores to display on the leaderboard. If this is 0, there is no max length.
@export var max_length := 0

## Font size for the values in the head and the score's font size
@export var value_size := 25

func _enter_tree():
	
	var scroll_container = ScrollContainer.new()
	add_child(scroll_container)
	var vbox = VBoxContainer.new()
	scroll_container.add_child(vbox)
	vbox.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
	vbox.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
	var space = HBoxContainer.new()
	vbox.add_child(space)
	space.custom_minimum_size.y = 90
	space.name = "Space"
	
	var background = ColorRect.new()
	add_child(background)
	var title = Label.new()
	add_child(title)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var header = HBoxContainer.new()
	add_child(header)


func _process(delta: float) -> void:
	theme = leaderboard_theme
	get_child(0).size = size
	get_child(1).color = head_color
	get_child(1).size = Vector2(size.x, 90)
	get_child(2).size = Vector2(size.x, 49)
	get_child(2).text = leaderboard_name
	
	var header = get_child(3)
	header.size.x = size.x
	header.position.y = 53
	
	for child in header.get_children():
		child.queue_free()
	
	for text in headers:
		#print(text)
		var new_label = Label.new()
		header.add_child(new_label)
		if text != null:
			new_label.text = text
		new_label.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		new_label.add_theme_font_size_override("font_size", value_size)
	
	var vbox = get_child(0).get_child(0)
	for child in vbox.get_children():
		if child.name != "Space":
			child.queue_free()
	
	var i = 1
	for score in scores:
		if i <= max_length or max_length == 0: #Limit the max size to max_length
			var new_score = HBoxContainer.new()
			vbox.add_child(new_score)
			new_score.size.x = size.x
			for value in headers:
				var new_label = Label.new()
				new_score.add_child(new_label)
				if value in score:
					new_label.text = str(score[value])
				elif value == "Placement":
					if len(str(i)) > 1:
						if int(str(i)[-2]) != 1:
							if int(str(i)[-1]) == 1:
								new_label.text = str(i) + "st"
							elif int(str(i)[-1]) == 2:
								new_label.text = str(i) + "nd"
							elif int(str(i)[-1]) == 3:
								new_label.text = str(i) + "rd"
							else:
								new_label.text = str(i) + "th"
						else:
							new_label.text = str(i) + "th"
					else:
						if int(str(i)[-1]) == 1:
							new_label.text = "1st"
						elif int(str(i)[-1]) == 2:
							new_label.text = "2nd"
						elif int(str(i)[-1]) == 3:
							new_label.text = "3rd"
						else:
							new_label.text = str(i) + "th"
				new_label.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
				new_label.add_theme_font_size_override("font_size", value_size)
			i += 1
