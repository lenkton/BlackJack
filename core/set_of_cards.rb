require_relative 'bj_exception'

class SetOfCards
  def
    initialize(init_deck = [])
    raise BJException, 'init_deck must be an array' unless init_deck.is_a?(Array)

    @cards = init_deck
  end

  def add_card(card)
    @cards << card
  end

  protected

  def wipe
    @cards = []
  end

  attr_reader :cards
end
