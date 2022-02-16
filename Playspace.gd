extends Node2D


# Declare member variables here. Examples:
const CardBase = preload("res://CardBase.tscn")
var selected_card_index: int = -1


func _ready():
	# Change seed (makes it actually random)
	randomize()
	#Setup Button Container
	$ButtonRegions.rect_position = Vector2(get_viewport().size * Vector2(0, 0.5))
	$ButtonRegions.rect_size = Vector2(get_viewport().size * Vector2(1, 0.5))
	#Put the first card on the timeline
	GameEvents.emit_signal("draw_card")
	
	
	
	GameEvents.connect("place_card", self, "display_new_card")


func display_new_card(card: CardTemplate):
	var card_index: int = get_correct_card_index(card)
	var new_card: CardBase = CardBase.instance()
	new_card.card_resource = card
	
	$Cards.add_child(new_card)
	$Cards.move_child(new_card, card_index)
	
	place_cards()
	$ButtonRegions.create_buttons( $Cards.get_child_count() )


func get_correct_card_index(card: CardTemplate) -> int:
	var card_array: Array = $Cards.get_children()
	var correct_index: int = card_array.size()

	if(card_array.size() == 0):
		return 0

	for i in range(card_array.size()):
		if card_array[i].is_card_earlier(card):
			correct_index = i
			break

	return correct_index


func place_cards() -> void:
	var cards = $Cards.get_children()
	#Position the cards in the view
	for i in range(cards.size()):
		cards[i].set_timeline_position(i, cards.size())


func _on_StartButton_pressed():
	GameEvents.emit_signal("draw_card")
	$StartButton.remove_and_skip()
