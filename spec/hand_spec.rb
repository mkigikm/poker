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

  let(:four_of_a_kind) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:queen, :diamonds),
      Card.new(:queen, :clubs),
      Card.new(:queen, :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:king_queen_boat) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:king,  :diamonds),
      Card.new(:king,  :clubs),
      Card.new(:queen, :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:queen_king_boat) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:queen, :diamonds),
      Card.new(:king,  :clubs),
      Card.new(:queen, :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:flush) {
    Hand.new([
      Card.new(:ace,   :spades),
      Card.new(:deuce, :spades),
      Card.new(:three, :spades),
      Card.new(:four,  :spades),
      Card.new(:six,   :spades)
    ].shuffle)
  }

  let(:ace_high_straight) {
    Hand.new([
      Card.new(:ace,   :spades),
      Card.new(:king,  :spades),
      Card.new(:queen, :spades),
      Card.new(:jack,  :spades),
      Card.new(:ten,   :hearts)
    ].shuffle)
  }

  let(:ace_low_straight) {
    Hand.new([
      Card.new(:ace,   :spades),
      Card.new(:deuce, :spades),
      Card.new(:three, :spades),
      Card.new(:four,  :spades),
      Card.new(:five,  :hearts)
    ].shuffle)
  }

  let(:three_of_a_kind) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:king,  :diamonds),
      Card.new(:king,  :clubs),
      Card.new(:four,  :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:two_pair) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:king,  :diamonds),
      Card.new(:four,  :clubs),
      Card.new(:four,  :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:pair) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:ace,   :diamonds),
      Card.new(:four,  :clubs),
      Card.new(:queen, :spades),
      Card.new(:king,  :spades)
    ].shuffle)
  }

  let(:high_card) {
    Hand.new([
      Card.new(:queen, :hearts),
      Card.new(:ace,   :diamonds),
      Card.new(:four,  :clubs),
      Card.new(:ten,   :spades),
      Card.new(:king,  :spades)
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

    it "identifies four of a kind" do
      value, card_order = four_of_a_kind.value
      expect(value).to be :four_of_a_kind
      expect(card_order.last.rank).to be :king
    end

    it "identifies full house" do
      value, card_order = king_queen_boat.value
      expect(value).to be :full_house
      expect(card_order.first.rank).to be :king
      expect(card_order[3].rank).to be :queen
    end

    it "orders full houses correctly" do
      value, card_order = queen_king_boat.value
      expect(value).to be :full_house
      expect(card_order.first.rank).to be :queen
      expect(card_order[3].rank).to be :king
    end

    it "identifies flushes" do
      value, card_order = flush.value
      expect(value).to be :flush
    end

    it "identifies straights" do
      value, card_order = ace_high_straight.value
      expect(value).to be :straight
    end

    it "identifies ace low straights" do
      value, card_order = ace_low_straight.value
      expect(value).to be :straight
      expect(card_order.first.rank).to be :five
      expect(card_order.last.rank).to be :ace
    end

    it "identifies three of a kind" do
      value, card_order = three_of_a_kind.value
      expect(value).to be :three_of_a_kind
      expect(card_order.first.rank).to be :king
      expect(card_order[3].rank).to be :queen
      expect(card_order.last.rank).to be :four
    end

    it "identifies two pair" do
      value, card_order = two_pair.value
      expect(value).to be :two_pair
      expect(card_order.first.rank).to be :king
      expect(card_order[2].rank).to be :four
      expect(card_order.last.rank).to be :queen
    end

    it "identifies pairs" do
      value, card_order = pair.value
      expect(value).to be :pair
      expect(card_order.first.rank).to be :queen
      expect(card_order[2].rank).to be :ace
      expect(card_order[3].rank).to be :king
      expect(card_order.last.rank).to be :four
    end

    it "identifies high card" do
      value, card_order = high_card.value
      expect(value).to be :high_card
      expect(card_order.first.rank).to be :ace
      expect(card_order[1].rank).to be :king
      expect(card_order[2].rank).to be :queen
      expect(card_order[3].rank).to be :ten
      expect(card_order.last.rank).to be :four
    end
  end

  describe "#<=>" do
    it "ranks hands according to value" do
      hands = [
        royal_flush,
        four_of_a_kind,
        king_queen_boat,
        flush,
        ace_high_straight,
        three_of_a_kind,
        two_pair,
        pair,
        high_card
      ]

      hands.each_cons(2) do |h0, h1|
        expect(h0 > h1).to be true
      end
    end

    it "breaks ties with highest card" do
      expect(royal_flush > ace_low_straight_flush).to be true
    end

    it "correctly identifies ties" do
      expect(royal_flush == royal_flush).to be true
    end
  end

  describe "::winning_hands" do
    it "returns [] when given no hands" do
      expect(Hand.winning_hands([])).to eq([])
    end

    it "identifies when one hand is best" do
      expect(Hand.winning_hands([royal_flush, pair])).to \
        contain_exactly(royal_flush)
    end

    it "identifies ties" do
      other_high_card = Hand.new(
        [
          Card.new(:queen, :diamonds),
          Card.new(:ace,   :spades),
          Card.new(:four,  :hearts),
          Card.new(:ten,   :clubs),
          Card.new(:king,  :clubs)
        ].shuffle)

      expect(Hand.winning_hands([high_card, other_high_card])).to \
        contain_exactly(high_card, other_high_card)
    end
  end
end
