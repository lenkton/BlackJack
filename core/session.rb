require_relative 'game'

class Session
  attr_reader :player, :dealer

  def initialize(name = 'New Player')
    @player = Player.new(name, [], 100)
    @dealer = Player.new('dealer', [], 100)
    @game = Game.new(@player, @dealer)
    # @game_state = @game.state
  end

  (Game.instance_methods - Session.instance_methods).each do |meth|
    define_method(meth) do # possible bugs with the methods which take arguments
      @game.send meth
    end
  end
end
