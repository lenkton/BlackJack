require_relative 'set_of_cards'
require_relative 'game'

class Hand < SetOfCards
  attr_reader :cards

  def value
    aces = 0
    total = cards.inject(0) do |res, card|
      case card.name
      when /[K,T,Q,J]/ then res + Game::DEFAULT_TJQK_VALUE
      when /A/
        aces += 1
        res + Game::ACE_MAX
      when /[2-9]/ then res + card.name.to_i
      else raise BJException, 'Incorrect Card name'
      end
    end

    total > Game::WIN_POINTS ? true_aces_value(total, aces) : total
  end

  private

  def true_aces_value(total, aces)
    [((total - Game::WIN_POINTS + Game::ACE_DIF - 1) / Game::ACE_DIF), aces].min * Game::ACE_DIF
  end
end
