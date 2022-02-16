extends Node

var deck_resource_list: Array
var next_card_index: int
const PATH_TO_CARDS = 'res://Assets/Cards'

func _ready():
	randomize()
	create_deck()
	shuffle_deck()
	
	GameEvents.connect("show_first_card", self, "on_show_first_card")
	GameEvents.connect("place_card", self, "on_place_card")
	GameEvents.connect("draw_card", self, "on_draw_card")
	GameEvents.connect("end_game", self, "on_end_game")


func create_deck():
	var path: String = PATH_TO_CARDS
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				deck_resource_list.append(file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path." + str(dir.open(path)))


func shuffle_deck():
	deck_resource_list = shuffle_list(deck_resource_list)
	deck_resource_list = deck_resource_list.slice(0,10)

func shuffle_list(list) -> Array:
	var shuffled_list = [] 
	var index_list = range(list.size())
	for i in range(list.size()):
		var x = randi()%index_list.size()
		shuffled_list.append(list[index_list[x]])
		index_list.remove(x)
	return shuffled_list


func on_show_first_card():
	pass


func on_place_card():
	pass


func on_draw_card():
	if next_card_index >= deck_resource_list.size():
		GameEvents.emit_signal("end_game")
		return
	
	var card_resource: CardTemplate = get_card_resource()
	next_card_index += 1
	
	GameEvents.emit_signal("card_drawn", card_resource)


func get_card_resource() -> CardTemplate:
	var next_card_path = PATH_TO_CARDS + "/" + deck_resource_list[next_card_index]
	#return ResourceLoader.load(next_card_path) as CardTemplate
	return load(next_card_path) as CardTemplate


func on_end_game():
	print("END GAME!")
	GameEvents.disconnect("draw_card", self, "on_draw_card")
