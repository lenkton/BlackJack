require_relative 'player'
require_relative 'deck'
require_relative 'bj_exception'
require_relative 'game_state'

class Game
  def initialize(player, dealer, bet = 10)
    @deck = Deck.new
    @deck.shuffle!
    (@player = player).wipe_hand
    (@dealer = dealer).wipe_hand
    @is_final = false
    @bank = player.take_money(bet)
    begin
      @bank = dealer.take_money(bet)
    rescue NoMoneyException => e
      player.give_money(@bank)
      raise e
    end
  end

  def state
    if @is_final
      GameState.new(@dealer.hand, @player.hand, true)
    else
      dk = []
      @dealer.hand.size.times { dk << Card.new('*') }
      GameState.new(dk, @player.hand, false)
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

    end_game
    state
  end

  private

  def end_game
    @is_final = true

    state.winner.give_money(@bank)
  end

  def internal_state
    GameState.new(@dealer.hand, @player.hand)
  end

  def dealer_turn
    @dealer.add_card(@deck.take_card!) if internal_state.dealer_score < 17 && @dealer.hand.size < 3

    check_final!
  end

  def check_final!
    end_game if !@is_final && @player.hand.size == 3 && @dealer.hand.size == 3
  end
end
