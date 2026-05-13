extends Node

const IP_ADDRESS : String = "localhost"
const PORT : int = 33367

var peer : ENetMultiplayerPeer

func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = peer

func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
