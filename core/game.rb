require_relative 'player'
require_relative 'deck'
require_relative 'bj_exception'
require_relative 'game_state'

class Game
  def initialize(player_name = 'New Player')
    @deck = Deck.new
    @deck.shuffle!
    @player = Player.new(player_name, [@deck.take_card!, @deck.take_card!])
    @dealer = Player.new('the dealer', [@deck.take_card!, @deck.take_card!])
    @is_final = false
  end

  def state
    if @is_final
      GameState.new(@dealer.hand, @player.hand)
    else
      dk = []
      @dealer.hand.size.times { dk << Card.new('*') }
      GameState.new(dk, @player.hand)
    end
  end

  def pass
    raise BJException, 'Game has ended' if @is_final

    dealer_turn
    state
  end

  def take
    raise BJException, 'Game has ended' if @is_final

    raise BJException, 'The hand is already full' if @player.hand.size == 3

    @player.add_card(@deck.take_card!)

    dealer_turn
    state
  end

  def show_up
    raise BJException, 'Game has ended' if @is_final

    @is_final = true
    state
  end

  private

  def internal_state
    GameState.new(@dealer.hand, @player.hand)
  end

  def dealer_turn
    @dealer.add_card(@deck.take_card!) if internal_state.dealer_score < 17 && @dealer.hand.size < 3

    check_final!
  end

  def check_final!
    @is_final ||=
      @player.hand.size == 3 && @dealer.hand.size == 3
  end
end
