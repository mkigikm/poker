require_relative 'errors'

class Player
  attr_reader :name, :bankroll
  attr_accessor :hand

  def self.parse_bet(input)
    if input[0].upcase == "F"
      :fold
    elsif input[0].upcase == "C"
      :call
    else
      Integer(input)
    end
  end

  def self.parse_replace(input)
    input.split(",").map { |i| Integer(i) }
  end

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def can_bet?
    !folded? && bankroll > 0
  end

  def bet_turn(game)
    p hand.cards
    puts "Place your bet #{name} (C to call, F to fold): "
    action = self.class.parse_bet(gets.chomp)

    case action
    when :fold then fold(game.discard_deck)
    when :call then make_bet(game, game.current_bet)
    else make_bet(game, action)
    end

    rescue StandardError => e
      puts e
      retry

  end

  def discard_turn(game)
    puts hand
    puts "What cards would you like to replace (separate with commas): "
    to_replace = self.class.parse_replace(gets.chomp)
    replace_card(to_replace.map { |i| hand.cards[i] }, game.draw_deck,
      game.discard_deck)

    rescue
      puts e
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

  def replace_cards(to_remove, draw_deck, discard_deck)
    begin
      to_add = draw_deck.deal(to_remove.count)
      hand.replace(to_remove, to_add)
      discard_deck.return(to_remove)
    rescue PokerError => e
      draw_deck.return(to_add)
      raise e
    end
  end
end
