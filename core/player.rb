require_relative 'set_of_cards'

class Player < SetOfCards
  attr_reader :name

  def initialize(name = 'New Player', init_cards = [])
    @name = name
    super(init_cards)
  end

  def hand
    cards
  end
end
