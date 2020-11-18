require_relative 'player'
require_relative 'deck'

class GameState
  attr_reader :dealer_cards, :player_cards, :player_score, :dealer_score

  def initialize(dealer_cards, player_cards)
    @dealer_cards = dealer_cards
    @player_cards = player_cards
    @player_score = assess(@player_cards)
    @dealer_score = assess(@dealer_cards)
  end

  DEFAULT_TJQK_VALUE = 10
  WIN_POINTS = 21
  ACE_MAX = 11
  ACE_MIN = 1
  ACE_DIF = ACE_MAX - ACE_MIN

  private

  def assess(cards)
    aces = 0
    total = cards.inject(0) do |res, card|
      case card.name
      when '*' then '???'
      when /[K,T,Q,J]/ then res + DEFAULT_TJQK_VALUE
      when /A/
        aces += 1
        res + ACE_MAX
      when /[2..9]/ then res + card.name.to_i
      else raise BJException, 'Incorrect Card name'
      end
    end

    total > WIN_POINTS ? true_aces_value(total, aces) : total
  end

  def true_aces_value(total, aces)
    [((total - WIN_POINTS + ACE_DIF - 1) / ACE_DIF), aces].min * ACE_DIF
  end
end

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
      GameState.new(@dealer.cards, @player.cards)
    else
      dk = []
      @dealer.cards.size.times { dk << Card.new('*') }
      GameState.new(dk, @player.cards)
    end
  end

  def pass
    raise BJException, 'Game has ended' if @is_final

    dealer_turn
  end

  def take
    raise BJException, 'Game has ended' if @is_final

    raise BJException, 'The hand is already full' if @player.hand.size == 3

    @player.add_card(@deck.take_card!)

    dealer_turn
  end

  def show_up
    @is_final = true
  end

  private

  def dealer_turn
    if state.dealer_score < 17 && @dealer.hand.size < 3
      @dealer.add_card(@deck.take_card!)
    end

    check_final!
  end

  def check_final!
    @is_final ||=
      @player.hand.size == 3 && @dealer.hand.size == 3
  end
end

class BJException < RuntimeError; end
