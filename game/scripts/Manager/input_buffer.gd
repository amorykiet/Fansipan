extends Node2D
const BUFFER_WINDOW: int = 150

var keyboard_timestamps: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pause_mode = Node.PAUSE_MODE_PROCESS
	process_mode = Node.PROCESS_MODE_INHERIT
	
	# Initialize all dictionary entris.
	keyboard_timestamps = {}
	

# Called whenever the player makes an input.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.pressed or event.is_echo():
			return
		var scancode: int = event.physical_keycode
		
		keyboard_timestamps[scancode] = Time.get_ticks_msec()

# Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer window.
func is_action_press_buffered(action: String) -> bool:
	# Get the inputs associated with the action. If any one of them was pressed in the last BUFFER_WINDOW milliseconds,
	# the action is buffered.
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.physical_keycode
			if keyboard_timestamps.has(scancode):
				if Time.get_ticks_msec() - keyboard_timestamps[scancode] <= BUFFER_WINDOW:
					# Prevent this method from returning true repeatedly and registering duplicate actions.
					return true;
	# If there's ever a third type of buffer-able action (mouse clicks maybe?), it'd probably be worth it to generalize
	# the repetitive keyboard/joypad code into something that works for any input method. Until then, by the YAGNI 
	# principle, the repetitive stuff stays >:)
	
	return false


# Records unreasonable timestamps for all the inputs in an action. Called when IsActionPressBuffered returns true, as
# otherwise it would continue returning true every frame for the rest of the buffer window.
func comsume_action(action: String) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.physical_keycode
			if keyboard_timestamps.has(scancode):
				keyboard_timestamps[scancode] = 0
