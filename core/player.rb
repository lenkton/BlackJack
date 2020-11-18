require_relative 'set_of_cards'

class Player < SetOfCards
  def hand
    cards
  end
end
