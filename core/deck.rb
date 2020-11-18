class Deck < SetOfCards
  def initialize(init_deck = [])
    raise BJException, 'init_deck must be an array' unless init_deck.is_a?(Array)

    @cards = init_deck
  end

  def get_card
    @cards.pop
  end

  def add_card(card)
    @cards << card
  end

  def shuffle
    @cards.shuffle
  end
end
