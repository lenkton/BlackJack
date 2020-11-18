require_relative 'player'
require_relative 'deck'

class Game
  def initialize(player_name = 'New Player')
    @deck = Deck.new
    @deck.shuffle!
    @player = Player.new(player_name, [@deck.take_card!, @deck.take_card!])
    @dealer = Player.new('the dealer', [@deck.take_card!, @deck.take_card!])
  end
end
