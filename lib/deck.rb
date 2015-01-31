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
end
