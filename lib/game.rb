require_relative 'player'
require_relative 'deck'
require_relative 'errors'
require_relative 'hand'

class Game
  attr_accessor :current_bet, :draw_deck, :discard_deck

  def initialize
    @players = [Player.new("Matt", 1000), Player.new("John", 1000)]
    @draw_deck = Deck.standard_deck
    @discard_deck = Deck.new([])
    @stakes = Hash.new(0)
    @current_bet = 0
  end

  def place_bet(player, bet_size)
    if bet_size >= @current_bet || player.bankroll == 0
      @stakes[player] += @current_bet
      @current_bet = [bet_size, @current_bet].max
    else
      raise PokerError.new("bet is too small")
    end
  end

  def deal_hands
    @players.each do |player|
      player.hand = Hand.new(@draw_deck.deal(5)) if player.bankroll > 0
    end
  end

  def play_game
    deal_hands
    betting_round
  end

  def betting_round
    last_bets = Hash.new(0)
    no_bets = false
    last_raiser = @players.last
    current_better = @players.first
    better_idx = 0

    until last_bets[last_raiser] == @current_bet
      old_bet_size = @current_bet
      if current_better.can_bet?
        current_better.bet_turn(self)
        last_raiser = current_better if @current_bet > old_bet_size
      end
      better_idx = (better_idx + 1) % @players.count
      current_better = @players[better_idx]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play_game
end
