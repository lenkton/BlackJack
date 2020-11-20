require_relative 'set_of_cards'

class Hand < SetOfCards
  DEFAULT_TJQK_VALUE = 10
  WIN_POINTS = 21
  ACE_MAX = 11
  ACE_MIN = 1
  ACE_DIF = ACE_MAX - ACE_MIN

  def value
    aces = 0
    total = cards.inject(0) do |res, card|
      case card.name
      when /[K,T,Q,J]/ then res + DEFAULT_TJQK_VALUE
      when /A/
        aces += 1
        res + ACE_MAX
      when /[2-9]/ then res + card.name.to_i
      else raise BJException, 'Incorrect Card name'
      end
    end

    total > WIN_POINTS ? true_aces_value(total, aces) : total
  end

  private

  def true_aces_value(total, aces)
    [((total - WIN_POINTS + ACE_DIF - 1) / ACE_DIF), aces].min * ACE_DIF
  end
end
