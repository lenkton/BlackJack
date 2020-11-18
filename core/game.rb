require_relative 'player'
require_relative 'deck'
class Game
  def initialize(player_name = 'New Player')
    @players = [Player.new(player_name), Player.new('the dealer')]
    @deck = Deck.new
  end
end
