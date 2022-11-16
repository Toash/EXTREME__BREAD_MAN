extends Node

"""
Places text at positions in game. Useful for popping
letters onto the screen 
"""

func place_text(parent:Node,rel_pos:Vector2,text:String,time):
	var spawn_node = Node2D.new()
	var spawn_text = Label.new()
	var spawn_timer = Timer.new()
	spawn_node.add_child(spawn_text)
	spawn_text.text = text
	spawn_node.add_child(spawn_timer)
	spawn_timer.wait_time = time
	spawn_timer.connect("timeout",spawn_node,"queue_free")
	parent.add_child(spawn_node)
	spawn_node.position = rel_pos
	
