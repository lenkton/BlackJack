require_relative 'set_of_cards'

class Player < SetOfCards
  attr_reader :name

  def initialize(name = 'New Player', cards = [])
    @name = name
    super(cards)
  end

  def hand
    cards
  end
end
