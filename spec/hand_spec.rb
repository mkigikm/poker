require 'hand'
require 'card'
require 'deck'

describe Hand do
  let(:full_deck) { Deck.standard_deck }
  let(:hand) { Hand.new(full_deck.deal(5)) }

  describe "#initialize" do
    it "creates a hand from an array of cards" do
      cards = Card.all_cards
      hand = Hand.new(cards)
      expect(hand.cards).to include(*cards)
    end
  end

  describe "#replace" do
    it "only replaces cards that are in the hand" do
      expect { hand.replace(full_deck.deal(3), []) }.to \
        raise_error("those cards aren't in the hand")
    end

    let(:to_remove) { hand.cards[0..1] }
    let(:to_replace) { full_deck.deal(2) }

    it "returns and removes cards that are being replaced" do
      removed = hand.replace(to_remove, to_replace)
      expect(removed).to eq(to_remove)
      expect(hand.cards).to_not include(*to_remove)
    end

    it "only replaces an equal number of cards" do
      expect { hand.replace(to_remove, []) }.to \
        raise_error "must replace all the removed cards"
    end

    it "adds cards that are being added" do
      hand.replace(to_remove, to_replace)
      expect(hand.cards).to include(*to_replace)
    end
  end

  let(:royal_flush) {
    Hand.new([
      Card.new(:ace,   :spades),
      Card.new(:king,  :spades),
      Card.new(:queen, :spades),
      Card.new(:jack,  :spades),
      Card.new(:ten,   :spades)
    ].shuffle)
  }

  let(:ace_low_straight_flush) {
    Hand.new([
      Card.new(:ace,   :spades),
      Card.new(:deuce, :spades),
      Card.new(:three, :spades),
      Card.new(:four,  :spades),
      Card.new(:five,  :spades)
    ].shuffle)
  }

  describe "#value" do
    it "identifies straight flushes" do
      value, card_order = royal_flush.value
      correct_card_order = Card.order(royal_flush.cards)
      expect(value).to be :straight_flush
      expect(card_order).to eq(correct_card_order)
    end

    it "identifies ace low straight flushes" do
      value, card_order = ace_low_straight_flush.value
      correct_card_order = Card.order(ace_low_straight_flush.cards, true)
      expect(value).to be :straight_flush
      expect(card_order).to eq(correct_card_order)
    end

    it "identifies four of a kind"
    it "identifies full house"
    it "identifies flushes"
    it "identifies straights"
    it "identifies three of a kind"
    it "identifies two pair"
    it "identifies pairs"
    it "identifies high card"
  end
end
