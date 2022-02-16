extends MarginContainer


export(NodePath) onready var card_date = get_node(card_date) as Label
export(NodePath) onready var card_image = get_node(card_image) as TextureRect
export(Resource) var card_resource  = card_resource as CardTemplate

class_name CardBase

var cardIndex: int = 0
var sort_date: Dictionary
const CardSize: Vector2 = Vector2(250,350)


func _ready():
	rect_pivot_offset = rect_size/2
	sort_date = {
		"year": card_resource.date_year,
		"month": card_resource.date_month,
		"day": card_resource.date_day
	}
	card_date.text = "{month}/{day}/{year}".format(sort_date)
	card_image.texture = card_resource.card_image
	card_image.expand = true
	rect_size *= CardSize/rect_size

func is_card_earlier(card: CardTemplate):
	if int(card.date_year) < int(sort_date.year):
		return true
	if int(card.date_year) == int(sort_date.year):
		if int(card.date_month) < int(sort_date.month):
			return true
		if int(card.date_month) == int(sort_date.month):
			if int(card.date_day) < int(sort_date.day):
				return true
	
	return false


func set_timeline_position(index: int, total: int):
	rect_position = Vector2(get_viewport().size * Vector2((index + 1.0)/(total + 1), 0.8) + Vector2(-CardSize/2))
