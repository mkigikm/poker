class Card
  attr_reader :rank, :suit
  SUITS = {
      clubs:    "♣",
      diamonds: "♦",
      hearts:   "♥",
      spades:   "♠"
    }
  RANKS = {
      deuce: "2",
      three: "3",
      four:  "4",
      five:  "5",
      six:   "6",
      seven: "7",
      eight: "8",
      nine:  "9",
      ten:   "10",
      jack:  "J",
      queen: "Q",
      king:  "K",
      ace:   "A"
    }

  def self.all_cards
    SUITS.keys.collect_concat do |suit|
      RANKS.keys.collect do |rank|
        Card.new(rank, suit)
      end
    end
  end

  def self.order(cards, ace_low=false)
    cards.sort { |c0, c1| c1.compare(c0, ace_low) }
  end

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other_card)
    return false unless other_card.is_a?(self.class)

    rank == other_card.rank && suit == other_card.suit
  end

  def compare(other_card, ace_low=false)
    unless other_card.is_a?(self.class)
      raise ArgumentError.new("expected a Card")
    end

    rank_value(ace_low) <=> other_card.rank_value(ace_low)
  end

  def rank_value(ace_low=false)
    rank == :ace && ace_low ? -1 : RANKS.keys.index(rank)
  end

  def inspect
    "#{RANKS[rank]}#{SUITS[suit]}"
  end
end
