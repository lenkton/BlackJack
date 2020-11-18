class Deck < SetOfCards
  def get_card
    @cards.pop
  end

  def add_card(card)
    @cards << card
  end

  def shuffle
    @cards.shuffle
  end
end
