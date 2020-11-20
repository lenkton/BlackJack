require_relative 'bj_exception'

class SetOfCards
  def
    initialize(init_deck = [])
    raise BJException, 'init_deck must be an array' unless init_deck.is_a?(Array)

    @cards = init_deck
  end

  def size
    @cards.size
  end

  def add_card(card)
    @cards << card
  end

  def wipe
    @cards = []
  end

  protected

  attr_reader :cards
end
