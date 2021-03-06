require_relative 'card'

class Deck
  attr_reader :cards

  def self.standard_deck
    Deck.new(Card.all_cards)
  end

  def initialize(cards)
    @cards = cards
  end

  def shuffle
    cards.shuffle!
    self
  end

  def deal(num)
    raise "not enough cards in deck" if num > cards.count
    cards.shift(num)
  end

  def return(cards)
    raise "decks only contain cards" unless cards.all? { |c| c.is_a?(Card) }
    @cards.concat(cards)
  end
end
