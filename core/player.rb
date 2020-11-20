require_relative 'set_of_cards'
require_relative 'bj_exception'
require_relative 'hand'

class NoMoneyException < BJException; end

class Player
  attr_reader :name, :money, :hand

  def initialize(name = 'New Player', init_cards = [], money = 100)
    @name = name
    @money = money
    @hand = Hand.new(init_cards)
  end

  def wipe_hand
    @hand.wipe
  end

  def take_money(bet)
    raise NoMoneyException, "Player #{@name} has not enough money" if @money < bet

    @money -= bet
    bet
  end

  def give_money(money)
    @money += money
  end
end
