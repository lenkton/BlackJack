class Card
  attr_reader :name

  SUITS = ['♥', '♦', '♣', '♠'].freeze
  RANKS = %w[A 2 3 4 5 6 7 8 9 T J Q K].freeze
  CORRECT_FORM = /^[A2-9TJQK][♥♦♣♠]$/.freeze

  def initialize(name)
    raise BJException, "Inappropriate Card name class: #{name.class}" if name.class != String
    raise BJException, "Inappropriate Card name: #{name}" if name.chars[0] =~ CORRECT_FORM

    @name = name
  end
end
