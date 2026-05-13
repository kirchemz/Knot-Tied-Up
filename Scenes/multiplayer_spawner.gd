extends MultiplayerSpawner

@export var network_player : PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)

func spawn_player(id: int):
	if !multiplayer.is_server(): return
	
	var player : Node = network_player.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).call_deferred("add_child", player)
	if not is_instance_valid($"..".player_1):
		$"..".player_1 = player
	elif not is_instance_valid($"..".player_2):
		$"..".player_2 = player
