require_relative 'set_of_cards'
require_relative 'card'

class Deck < SetOfCards
  def initialize
    cards = []
    super(cards)
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank| # T == 10, like in pro poker :D
        cards << Card.new(rank + suit)
      end
    end
  end

  def take_card!
    @cards.pop
  end

  def shuffle!
    @cards.shuffle!
  end
end
