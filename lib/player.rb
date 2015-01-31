class Player
  attr_reader :name, :bankroll
  attr_accessor :hand

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def can_bet?
    !folded? && bankroll > 0
  end

  def make_bet(game, bet_size)
    raise "can't bet more than your bankroll" if bet_size > bankroll
    raise "can't bet a negative amount" if bet_size < 0

    game.place_bet(self, bet_size)
    @bankroll -= bet_size
  end

  def folded?
    hand.nil?
  end

  def fold(deck)
    raise "can't fold with no hand" if folded?
    deck.return(hand.cards)
    @hand = nil
  end
end
