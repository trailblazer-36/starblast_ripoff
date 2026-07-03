extends Control


func _on_server_pressed() -> void:
	SimpleNetworkHandler.start_server()


func _on_client_pressed() -> void:
	SimpleNetworkHandler.start_client()
