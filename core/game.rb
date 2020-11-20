require_relative 'player'
require_relative 'deck'
require_relative 'bj_exception'
require_relative 'game_state'

class Game
  def initialize(player, dealer, bet = 10)
    @deck = Deck.new
    @deck.shuffle!
    @player = player
    @dealer = dealer

    give_start_cards

    @is_final = false
    form_bank(bet)
  end

  def give_start_cards
    [@player, @dealer].each do |person|
      person.hand.wipe
      2.times { person.hand.add_card(@deck.take_card!) }
    end
  end

  def form_bank(bet)
    @bank = player.take_money(bet)
    begin
      @bank += dealer.take_money(bet)
    rescue NoMoneyException => e
      player.give_money(@bank)
      raise e
    end
  end

  def state
    if @is_final
      internal_state
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

    @player.hand.add_card(@deck.take_card!)

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

    if (winner = state.winner) == :nowinner
      @player.give_money(@bank / 2)
      @dealer.give_money(@bank / 2)
    else
      winner.give_money(@bank)
    end
  end

  def internal_state
    GameState.new(@dealer.hand, @player.hand, @is_final, @player, @dealer)
  end

  def dealer_turn
    @dealer.hand.add_card(@deck.take_card!) if internal_state.dealer_score < 17 && @dealer.hand.size < 3

    check_final!
  end

  def check_final!
    end_game if !@is_final && @player.hand.size == 3 && @dealer.hand.size == 3
  end
end
