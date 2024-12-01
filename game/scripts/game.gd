extends Node

const SCREEN_SCALE: float = 4

@onready var player = $ForegroundWorld/WorldViewport/World/Delta as Player
@onready var world_viewport = $ForegroundWorld/WorldViewport as SubViewport
@onready var world = $ForegroundWorld/WorldViewport/World as Node2D
