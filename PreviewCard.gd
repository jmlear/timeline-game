extends TextureRect

var preview_card: CardTemplate

func _ready():
	GameEvents.connect("card_drawn", self, "show_new_card")
	GameEvents.connect("end_game", self, "on_end_game")
	
	rect_size = get_viewport().size/2
	rect_position = Vector2(get_viewport().size.x/4, 10)
	expand = true
	stretch_mode = STRETCH_KEEP_ASPECT_CENTERED


func show_new_card(card: CardTemplate):
	print("PreviewCard show new card")
	if preview_card:
		GameEvents.emit_signal("place_card", preview_card)
	else:
		print("NO preview card")
	
	preview_card = card
	update_card()


func update_card():
	texture = preview_card.card_image


func on_end_game():
	GameEvents.emit_signal("place_card", preview_card)
	visible = false
