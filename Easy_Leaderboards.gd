@tool
extends EditorPlugin
#Created by Asher Petersen for Godot.


func _enable_plugin() -> void:
	add_autoload_singleton("Leaderboard", "res://addons/Easy_Leaderboards/Leaderboard.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("Leaderboard")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
