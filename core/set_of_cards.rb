class SetOfCards
  def
    initialize(init_deck = [])
    raise BJException, 'init_deck must be an array' unless init_deck.is_a?(Array)

    @cards = init_deck
  end

  protected

  attr_reader :cards

  def add_card(card)
    @cards << card
  end
end
