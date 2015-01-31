require 'deck'
require 'card'

describe Deck do
  let(:standard_deck) { Deck.standard_deck }

  describe "#initialize" do
    it "creates a deck from an array of cards" do
      clubs = Card.all_cards[0..12]
      deck = Deck.new(clubs)
      expect(deck.cards).to contain_exactly(*clubs)
    end
  end

  describe "#standard_deck" do
    it "creates a deck with 52 cards" do
      expect(standard_deck.cards).to contain_exactly(*Card.all_cards)
    end
  end

  describe "#shuffle" do
    it "changes the order of the deck randomly" do
      expect(standard_deck.cards == Deck.standard_deck.cards).to be true
      standard_deck.shuffle
      expect(standard_deck.cards == Deck.standard_deck.cards).to be false
    end
  end

  describe "#deal" do
    it "returns n cards from the top of the deck"

    it "removes the cards from the deck"

    it "won't allow a deal of more cards than are in the deck"
  end
end
