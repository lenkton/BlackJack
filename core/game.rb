class Game
  def initialize(player_name = 'New Player')
    @players = [Player(player_name), Player('the dealer')]
  end
end
