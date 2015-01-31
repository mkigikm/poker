require 'deck'
require 'card'

describe Deck do
  let(:standard_deck) { Deck.standard_deck }

  describe "#initialize" do
    it "creates a deck from an array of cards" do
      clubs = Card.all_cards[0..12]
      deck = Deck.new(clubs)
      expect(deck.cards).to include(*clubs)
    end
  end

  describe "#standard_deck" do
    it "creates a deck with 52 cards" do
      expect(standard_deck.cards).to include(*Card.all_cards)
    end
  end

  describe "#shuffle" do
    it "changes the order of the deck randomly" do
      expect(standard_deck.cards == Deck.standard_deck.cards).to be true
      standard_deck.shuffle
      expect(standard_deck.cards == Deck.standard_deck.cards).to be false
    end
  end

  let(:top_five) { Card.all_cards[0..4] }

  describe "#deal" do
    it "returns n cards from the top of the deck" do
      dealt_cards = standard_deck.deal(5)
      expect(dealt_cards).to eq(top_five)
    end

    it "removes the cards from the deck" do
      standard_deck.deal(5)
      expect(standard_deck.cards).to_not include(*top_five)
    end

    it "won't allow a deal of more cards than are in the deck" do
      expect { standard_deck.deal(53) }.to \
        raise_error("not enough cards in deck")
    end
  end

  describe "#return" do
    it "return n cards to the top of the deck" do
      standard_deck.return(top_five)
      expect(standard_deck.cards.last(5)).to eq(top_five)
    end

    it "only returns cards" do
      expect { standard_deck.return(top_five + [Object.new]) }.to \
        raise_error("decks only contain cards")
    end
  end
end
