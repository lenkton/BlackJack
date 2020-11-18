class Deck < SetOfCards
  def top_card!
    @cards.pop
  end

  def add_card(card)
    @cards << card
  end

  def shuffle
    @cards.shuffle
  end
end
