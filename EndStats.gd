extends Label

export(NodePath) onready var cards = get_node(cards) as Node

func _ready():
	visible = false
	rect_position = Vector2(get_viewport().size.x/4, 10)
	GameEvents.connect("show_stats", self, "on_show_stats")


func on_show_stats(incorrect_guesses: int):
	text = "Number of cards: " + str(cards.get_child_count())
	text += "\nIncorrect guesses: " + str(incorrect_guesses)
	visible = true
