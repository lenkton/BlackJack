require_relative 'set_of_cards'
require_relative 'card'

class Deck < SetOfCards
  def initialize
    cards = []
    super(cards)
    '♥♦♣♠'.each_char do |suit|
      'A23456789TJQK'.each_char do |rank| # T == 10, like in pro poker :D
        cards << Card.new(rank + suit)
      end
    end
  end

  def top_card!
    @cards.pop
  end

  def add_card(card)
    @cards << card
  end

  def shuffle!
    @cards.shuffle!
  end
end
