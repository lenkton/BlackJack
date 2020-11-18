require_relative 'set_of_cards'

class Player < SetOfCards
  attr_reader :name
  attr_accessor :money

  def initialize(name = 'New Player', init_cards = [], money = 100)
    @name = name
    @money = money
    super(init_cards)
  end

  def wipe_hand
    wipe
  end

  def hand
    cards
  end
end
