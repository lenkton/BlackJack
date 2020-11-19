require_relative 'set_of_cards'
require_relative 'bj_exception'

class NoMoneyException < BJException; end

class Player < SetOfCards
  attr_reader :name, :money

  def initialize(name = 'New Player', init_cards = [], money = 100)
    @name = name
    @money = money
    super(init_cards)
  end

  def wipe_hand
    wipe
  end

  def take_money(bet)
    raise NoMoneyException, "Player #{@name} has not enough money" if @money < bet

    @money -= bet
    bet
  end

  def give_money(money)
    @money += money
  end

  def hand
    cards
  end
end
