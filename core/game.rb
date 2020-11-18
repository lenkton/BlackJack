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

  private

  def assess(cards)
    cards.inject(0) do |res, card|
      case card.name
      when '*' then '???'
      when /[K,T,Q,J]/ then res + DEFAULT_TJQK_VALUE
      when /A/ then raise 'IMPLEMENT ACE HANDLING!!'
      when /[2..9]/ then res + card.name.to_i
      else raise 'Incorrect Card name'
      end
    end
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
end
