require 'player'
require 'hand'
require 'deck'

describe Player do
  subject(:player) { Player.new("Matt", 1000) }
  let(:deck) { Deck.standard_deck }
  let(:hand) { Hand.new(deck.deal(5)) }

  describe "#initialize" do
    it "starts with a name, a bankroll" do
      expect(player.name).to eq("Matt")
      expect(player.bankroll).to be 1000
    end
  end

  describe "#can_bet?" do
    it "allows a bet when the player has a hand and a bankroll" do
      player.hand = hand
      expect(player.can_bet?).to be true
    end

    it "doesn't allow a bet when a player doesn't have a hand" do
      expect(player.can_bet?).to be false
    end

    it "doesn't allow a bet when a player's bankroll is 0" do
      bankrupt_player = Player.new("John", 0)
      bankrupt_player.hand = hand
      expect(bankrupt_player.can_bet?).to be false
    end
  end

  describe "#make_bet" do
    let(:game) { double(:game) }

    it "doesn't allow a bet bigger than the player's bankroll" do
      expect { player.make_bet(game, 2 * player.bankroll) }.to \
        raise_error("can't bet more than your bankroll")
    end

    it "doesn't allow negative bets" do
      expect { player.make_bet(game, -500) }. to \
        raise_error("can't bet a negative amount")
    end

    it "tells the game about the player's bet" do
      expect(game).to receive(:place_bet).with(player, 500)
      player.make_bet(game, 500)
    end

    it "deducts from the player's bankroll after a successful bet" do
      expect(game).to receive(:place_bet).with(player, 500)

      expect { player.make_bet(game, 500) }.to change \
        { player.bankroll }.by -500
    end

    it "doesn't allow bets less than the game's current bet" do
      old_bankroll = player.bankroll

      expect(game).to receive(:place_bet).with(player, 500) \
        .and_raise "can't bet less than the minimum of the " + \
                   "current bet and your bankroll"
      expect { player.make_bet(game, 500) }.to raise_error
      expect(player.bankroll).to be old_bankroll
    end
  end

  describe "#fold" do
    let (:fold_deck) { double(:deck) }
    it "sets the player's hand to nil" do
      player.hand = hand

      expect(fold_deck).to receive(:return).with(hand.cards)
      expect { player.fold(fold_deck) }.to change { player.hand }.to nil
    end

    it "returns the cards to the deck" do
      player.hand = hand

      expect(fold_deck).to receive(:return).with(hand.cards)
      player.fold(fold_deck)
    end

    it "doesn't let a player with no hand fold" do
      expect { player.fold(fold_deck) }.to \
        raise_error("can't fold with no hand")
    end
  end

  # describe "#replace_cards" do
  #   it
  # end
end
