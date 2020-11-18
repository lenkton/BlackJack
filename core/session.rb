require_relative 'game'

class Session
  def initialize(name = 'New Player')
    @player = Player.new(name, [], 100)
    @dealer = Player.new('dealer', [], 100)
    @game = Game.new(@player, @dealer)
  end
end
