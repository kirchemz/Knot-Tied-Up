extends Control

@onready var server_button = $VBoxContainer/Server
@onready var client_button = $VBoxContainer/Client
@onready var ip_input = $VBoxContainer/IPInput
@onready var port_input = $VBoxContainer/PortInput
@onready var status_label = $VBoxContainer/StatusLabel

const DEFAULT_PORT : int = 33367
var port : int = DEFAULT_PORT

func _ready() -> void:
	# Set up signal connections
	server_button.pressed.connect(_on_server_pressed)
	client_button.pressed.connect(_on_client_pressed)
	
	# Connect to server started signal to display server info
	HighLevelMultiplayerHandler.server_started.connect(_on_server_started)
	
	# Set default port value
	port_input.text = str(DEFAULT_PORT)
	
	# Update port when input changes
	port_input.text_changed.connect(func(new_text: String):
		if new_text.is_valid_int():
			port = int(new_text)
		else:
			port = DEFAULT_PORT
	)
	
	# Make IP input initially invisible for client
	ip_input.visible = false
	port_input.visible = false
	status_label.text = ""

func _on_server_pressed() -> void:
	# Parse port
	if port_input.text.is_valid_int():
		port = int(port_input.text)
	else:
		port = DEFAULT_PORT
	
	status_label.text = "Starting server on port %d..." % port
	ip_input.visible = false
	port_input.visible = false
	HighLevelMultiplayerHandler.start_server(port)

func _on_server_started(ip: String, port: int) -> void:
	# Display server info to user
	status_label.text = "Server running at %s:%d\nShare this IP with clients!" % [ip, port]

func _on_client_pressed() -> void:
	# Toggle visibility of input fields
	ip_input.visible = !ip_input.visible
	port_input.visible = !port_input.visible
	
	# If inputs are now hidden, that means we were already showing them - connect now
	if not ip_input.visible:
		var ip_address = ip_input.text.strip_edges()
		
		# Validate input
		if ip_address.is_empty():
			status_label.text = "Error: IP address cannot be empty"
			ip_input.visible = true
			port_input.visible = true
			return
		
		# Parse port
		if port_input.text.is_valid_int():
			port = int(port_input.text)
		else:
			port = DEFAULT_PORT
		
		status_label.text = "Connecting to %s:%d..." % [ip_address, port]
		HighLevelMultiplayerHandler.start_client(ip_address, port)
	else:
		# Show input fields
		status_label.text = "Enter server IP/hostname below"
		if ip_input.text.is_empty():
			ip_input.placeholder_text = "localhost or 192.168.1.100"
