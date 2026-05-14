extends Node

var peer : ENetMultiplayerPeer
var server_ip : String = ""
var server_port : int = 33367

# Signal for when server is started
signal server_started(ip: String, port: int)

func _ready() -> void:
	# Try to get local IP address on startup
	get_local_ip()

func get_local_ip() -> String:
	# Returns the local machine IP address
	# This is a simple approach - in production you might want more robust detection
	var hostname = OS.get_environment("HOSTNAME")
	if hostname.is_empty():
		hostname = "localhost"
	server_ip = hostname
	return server_ip

func set_server_ip(ip: String) -> void:
	# Allow manual setting of server IP
	server_ip = ip
	print("Server IP set to: %s" % server_ip)

func get_server_ip() -> String:
	return server_ip

func start_server(port: int = 33367) -> void:
	server_port = port
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	
	if error != OK:
		print("Failed to create server: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	
	# If server_ip wasn't set, try to get it
	if server_ip.is_empty():
		get_local_ip()
	
	print("Server started on port %d" % port)
	print("Server IP: %s" % server_ip)
	
	# Emit signal with server info
	server_started.emit(server_ip, port)

func start_client(ip_address: String, port: int = 33367) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip_address, port)
	
	if error != OK:
		print("Failed to connect to server at %s:%d - Error: %s" % [ip_address, port, error])
		return
	
	multiplayer.multiplayer_peer = peer
	print("Connecting to %s:%d" % [ip_address, port])
	
	# Optional: Add signal handlers for connection events
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_connected_to_server() -> void:
	print("Successfully connected to server!")

func _on_connection_failed() -> void:
	print("Failed to connect to server!")
	if peer:
		multiplayer.multiplayer_peer = null

func _on_server_disconnected() -> void:
	print("Disconnected from server!")
	if peer:
		multiplayer.multiplayer_peer = null
