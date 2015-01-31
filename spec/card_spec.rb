require 'card'

describe Card do
  let(:deuce_hearts) { Card.new(:deuce, :heart) }
  let(:deuce_clubs)  { Card.new(:deuce, :clubs) }
  let(:three_hearts) { Card.new(:three, :hearts) }

  describe "#==" do
    it "is false when compared to a different object" do
      expect(deuce_hearts == Object.new).to be false
    end

    it "is true when cards have the same suit and rank" do
      expect(deuce_hearts == deuce_hearts.dup).to be true
    end

    it "is false when cards have a different suit" do
      expect(deuce_hearts == deuce_clubs).to be false
    end

    it "is false when cards have a different rank" do
      expect(three_hearts == deuce_hearts).to be false
    end
  end

  describe "::all_cards" do
    it "returns 52 unique cards" do
      cards = Card.all_cards

      expect(cards.count).to be 52
      expect(cards.uniq.count).to be 52
      expect(cards.all? { |card| card.is_a?(Card) }).to be true
    end
  end

  describe "compare" do
    it "doesn't compare to other objects" do
      expect { deuce_hearts.compare(Object.new) }.to raise_error(ArgumentError)
    end

    it "detects cards before it in rank" do
      expect(deuce_hearts.compare(three_hearts)).to be -1
    end

    it "detects cards equal to it in rank" do
      expect(deuce_hearts.compare(deuce_clubs)).to be 0
    end

    it "detects cards below it in rank" do
      expect(three_hearts.compare(deuce_hearts)).to be 1
    end
  end
end
