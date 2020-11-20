require_relative 'player'
require_relative 'deck'
require_relative 'bj_exception'

class Game
  attr_reader :is_over

  DEFAULT_TJQK_VALUE = 10
  WIN_POINTS = 21
  ACE_MAX = 11
  ACE_MIN = 1
  ACE_DIF = ACE_MAX - ACE_MIN

  def initialize(player, dealer, bet = 10)
    @deck = Deck.new
    @deck.shuffle!
    @player = player
    @dealer = dealer

    give_start_cards

    @is_over = false
    form_bank(bet)
  end

  def give_start_cards
    [@player, @dealer].each do |person|
      person.hand.wipe
      2.times { person.hand.add_card(@deck.take_card!) }
    end
  end

  def form_bank(bet)
    @bank = @player.take_money(bet)
    begin
      @bank += @dealer.take_money(bet)
    rescue NoMoneyException => e
      @player.give_money(@bank)
      raise e
    end
  end

  def pass
    raise BJException, 'Game has ended' if @is_over

    dealer_turn
  end

  def take
    raise BJException, 'Game has ended' if @is_over

    raise BJException, 'The hand is already full' if @player.hand.size == 3

    @player.hand.add_card(@deck.take_card!)

    dealer_turn
  end

  def show_up
    raise BJException, 'Game has ended' if @is_over

    end_game
  end

  def winner
    raise BJException, 'The game is not over yet' unless @is_over

    player_score = @player.hand.value
    dealer_score = @dealer.hand.value

    return :nowinner if player_score == dealer_score || [player_score, dealer_score].min > WIN_POINTS
    return @dealer if player_score > WIN_POINTS
    return @player if dealer_score > WIN_POINTS

    player_score > dealer_score ? @player : @dealer
  end

  private

  def end_game
    @is_over = true

    if (winner = self.winner) == :nowinner
      @player.give_money(@bank / 2)
      @dealer.give_money(@bank / 2)
    else
      winner.give_money(@bank)
    end
  end

  def dealer_turn
    @dealer.hand.add_card(@deck.take_card!) if @dealer.hand.value < 17 && @dealer.hand.size < 3

    check_final!
  end

  def check_final!
    end_game if !@is_over && @player.hand.size == 3 && @dealer.hand.size == 3
  end
end
