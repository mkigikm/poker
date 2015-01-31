class Card
  attr_reader :rank, :suit
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [:deuce, :three, :four, :five, :six, :seven, :eight, :nine, :ten,
           :jack, :queen, :king, :ace]

  def self.all_cards
    SUITS.collect_concat do |suit|
      RANKS.collect do |rank|
        Card.new(rank, suit)
      end
    end
  end

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other_card)
    return false unless other_card.is_a?(self.class)

    rank == other_card.rank && suit == other_card.suit
  end

  def compare(other_card)
    unless other_card.is_a?(self.class)
      raise ArgumentError.new("expected a Card")
    end

    RANKS.index(rank) <=> RANKS.index(other_card.rank)
  end
end
