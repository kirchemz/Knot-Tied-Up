extends Node

var peer : ENetMultiplayerPeer

func start_server(port: int = 33367) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	
	if error != OK:
		print("Failed to create server: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Server started on port %d" % port)

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
