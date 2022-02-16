extends HBoxContainer

export(NodePath) onready var PreviewCard = get_node(PreviewCard) as TextureRect

const Incorrect_Image = preload("res://Assets/Images/Incorrect_Image.png")
const HoverTexture = preload("res://Assets/Images/Hover_Image.png")
var incorrect_guesses: int = 0

func _ready():
	GameEvents.connect("end_game", self, "send_stats")

func create_buttons(number_of_cards: int) -> void:
	if number_of_cards == 1:
		#On first run need to add 2 buttons
		var button_region1 = create_new_button( get_child_count() )
		add_child(button_region1)

	var button_region = create_new_button( get_child_count() )
	add_child(button_region)

	place_buttons()


func create_new_button(index: int) -> TextureButton:
	var button: TextureButton = TextureButton.new()
	button.texture_hover = HoverTexture
	button.texture_disabled = Incorrect_Image
	button.expand = true
	button.stretch_mode = 0
	button.connect("pressed", self, "button_pressed", [index])
	
	return button


func button_pressed(index: int) -> void:
	var correct_index: int = get_parent().get_correct_card_index(PreviewCard.preview_card)
	print('selected index ' + str(index) + ' correct: ' + str(correct_index))
	if index == correct_index:
		GameEvents.emit_signal("draw_card")
	else:
		incorrect_guesses += 1
		get_child(index).disabled = true


func place_buttons():
	var buttons = get_children()
	print('before editing button 0 ' + str(buttons[0].rect_size) + ', ' + str(buttons[0].rect_scale) + ', ' + str(buttons[0].rect_position))
	for i in range(buttons.size()):
		buttons[i].rect_position = Vector2(get_viewport().size * Vector2(float(i)/buttons.size(), 0))
		buttons[i].rect_min_size = Vector2(get_viewport().size * Vector2(1.0/buttons.size(), 0.5))
		buttons[i].disabled = false


func send_stats():
	GameEvents.emit_signal("show_stats", incorrect_guesses)
