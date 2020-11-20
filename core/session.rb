require_relative 'game'

class Session
  attr_reader :player, :dealer, :game

  def initialize(name = 'New Player')
    @player = Player.new(name, [], 100)
    @dealer = Player.new('dealer', [], 100)
    @game = Game.new(@player, @dealer)
  end

  def replay
    @game = Game.new(@player, @dealer) if @game.is_over
  end

  (Game.instance_methods - Session.instance_methods).each do |meth|
    define_method(meth) do # possible bugs with the methods which take arguments
      @game.send meth
    end
  end
end
