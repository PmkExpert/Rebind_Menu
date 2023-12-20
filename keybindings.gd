extends Control


var current_button : Button
var current_list = {}
var current_set : String

var duplicated : Button
var old_key


func _ready():
	for b1 in $SetA.get_children():
		if b1 is Button:
			b1.pressed.connect(_on_set_a_pressed.bind(b1))
			b1.get_node("input").text = InputMap.action_get_events(b1.name)[0].as_text().trim_suffix(" (Physical)")
	
	for b2 in $SetB.get_children():
		if b2 is Button:
			b2.pressed.connect(_on_set_b_pressed.bind(b2))
			b2.get_node("input").text = InputMap.action_get_events(b2.name)[0].as_text().trim_suffix(" (Physical)")


func _on_set_a_pressed(button: Button):
	reset_labels()
	
	current_button = button
	current_button.disabled = true
	current_button.get_node("input").text = "< waiting input >"
	current_set = "set_a"
	
	current_list = {}
	for b1 in $SetA.get_children():
		if b1 is Button:
			current_list[b1.name] = InputMap.action_get_events(b1.name)[0].as_text().trim_suffix(" (Physical)")

func _on_set_b_pressed(button: Button):
	reset_labels()
	
	current_button = button
	current_button.disabled = true
	current_button.get_node("input").text = "< waiting input >"
	current_set = "set_b"
	
	current_list = {}
	for b2 in $SetB.get_children():
		if b2 is Button:
			current_list[b2.name] = InputMap.action_get_events(b2.name)[0].as_text().trim_suffix(" (Physical)")


func reset_labels():
	if current_button:
		current_button.get_node("input").text = InputMap.action_get_events(str(current_button.name))[0].as_text().trim_suffix(" (Physical)")


func _input(event):
	if current_button:
		if event is InputEventKey || event is InputEventMouseButton:
			if event.is_released():
				
				if current_list.values().has(event.as_text()):
					for k in current_list.keys():
						if current_list[k] == event.as_text():
							if current_set == "set_a":
								duplicated = $SetA.get_node(k)
							if current_set == "set_b":
								duplicated = $SetB.get_node(k)
				else:
					duplicated = null
				if duplicated == current_button:
					duplicated = null
				
				old_key = InputMap.action_get_events(current_button.name)[0]
				InputMap.action_erase_events(current_button.name)
				InputMap.action_add_event(current_button.name, event)
				reset_labels()
				current_button.disabled = false
				current_button = null
				
				if duplicated != null:
					duplicated.grab_focus()
					InputMap.action_erase_events(duplicated.name)
					InputMap.action_add_event(duplicated.name, old_key)
					if current_set == "set_a":
						_on_set_a_pressed(duplicated)
					if current_set == "set_b":
						_on_set_b_pressed(duplicated)


