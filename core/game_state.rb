require_relative 'bj_exception'

class GameState
  attr_reader :dealer_cards, :player_cards, :player_score, :dealer_score, :has_ended

  def initialize(dealer_cards, player_cards, has_ended = false, player = nil, dealer = nil)
    @dealer_cards = dealer_cards
    @player_cards = player_cards
    @player_score = assess(@player_cards)
    @dealer_score = assess(@dealer_cards)
    @has_ended = has_ended
    @player = player
    @dealer = dealer
  end

  DEFAULT_TJQK_VALUE = 10
  WIN_POINTS = 21
  ACE_MAX = 11
  ACE_MIN = 1
  ACE_DIF = ACE_MAX - ACE_MIN

  def winner
    raise BJException, 'The game is not over' unless @has_ended

    raise BJException, 'The player is of wrong type' unless @player.is_a?(Player)
    raise BJException, 'The dealer is of wrong type' unless @dealer.is_a?(Player)

    return :nowinner if player_score == dealer_score || player_score > WIN_POINTS && dealer_score > WIN_POINTS
    return @dealer if player_score > WIN_POINTS
    return @player if dealer_score > WIN_POINTS

    player_score > dealer_score ? @player : @dealer
  end

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
      when /[2-9]/ then res + card.name.to_i
      else raise BJException, 'Incorrect Card name'
      end
    end

    total.is_a?(Integer) && total > WIN_POINTS ? true_aces_value(total, aces) : total
  end

  def true_aces_value(total, aces)
    [((total - WIN_POINTS + ACE_DIF - 1) / ACE_DIF), aces].min * ACE_DIF
  end
end
