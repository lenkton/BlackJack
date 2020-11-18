class GameState
  attr_reader :dealer_cards, :player_cards, :player_score, :dealer_score, :has_ended

  def initialize(dealer_cards, player_cards, has_ended = false)
    @dealer_cards = dealer_cards
    @player_cards = player_cards
    @player_score = assess(@player_cards)
    @dealer_score = assess(@dealer_cards)
    @has_ended = has_ended
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
