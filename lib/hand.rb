require_relative 'errors'

class Hand
  include Comparable

  HAND_RANKINGS = [
    :high_card,
    :pair,
    :two_pair,
    :three_of_a_kind,
    :straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush
  ]

  attr_reader :cards

  def self.winning_hands(hands)
    winners = hands.take(1)

    hands.drop(1).each do |new_hand|
      case winners.first <=> new_hand
      when  0 then winners << new_hand
      when -1 then winners = [new_hand]
      end
    end

    winners
  end

  def initialize(cards)
    @cards = cards
  end

  def replace(remove, add)
    unless remove.all? { |card| cards.include?(card) }
      raise PokerError.new("those cards aren't in the hand")
    end

    unless remove.count == add.count
      raise PokerError.new("must replace all the removed cards")
    end

    replacing = remove.count
    if replacing == 5 ||
        (remove.count == 4 && (cards - remove).first.rank != :ace)
      raise PokerError.new("can only replace three cards if not keeping an ace")
    end

    cards.delete_if { |card| remove.include?(card) }
    cards.concat(add)
    remove
  end

  def value
    groups            = group_by_rank
    sum_groups        = groups.inject(&:+)
    flush             = is_flush?
    ace_high_straight = is_straight?
    ace_low_straight  = is_straight?(true)
    ace_high_order    = Card.order(cards)
    ace_low_order     = Card.order(cards, true)

    if flush && ace_high_straight
      [:straight_flush,  ace_high_order]
    elsif is_flush? && ace_low_straight
      [:straight_flush,  ace_low_order]
    elsif groups[0].count == 4
      [:four_of_a_kind,  sum_groups]
    elsif groups[0].count == 3 && groups[1].count == 2
      [:full_house,      sum_groups]
    elsif flush
      [:flush,           ace_high_order]
    elsif ace_high_straight
      [:straight,        ace_high_order]
    elsif ace_low_straight
      [:straight,        ace_low_order]
    elsif groups[0].count == 3
      [:three_of_a_kind, sum_groups]
    elsif groups[0].count == 2 && groups[1].count == 2
      [:two_pair,        sum_groups]
    elsif groups[0].count == 2
      [:pair,            sum_groups]
    else
      [:high_card,       ace_high_order]
    end
  end

  def <=>(other_hand)
    my_value, my_card_order       = value
    other_value, other_card_order = other_hand.value

    if my_value != other_value
      HAND_RANKINGS.index(my_value) <=> HAND_RANKINGS.index(other_value)
    else
      my_card_order.zip(other_card_order).each do |(c0, c1)|
        case c0.compare(c1)
        when 1  then return 1
        when -1 then return -1
        end
      end
      0
    end
  end

  private
  def is_flush?
    cards.all? { |card| card.suit == cards[0].suit }
  end

  def is_straight?(ace_low=false)
    in_order = Card.order(cards, ace_low)
    in_order.each_cons(2).all? do |c0, c1|
      c0.rank_value(ace_low) - 1 == c1.rank_value(ace_low)
    end
  end

  def group_by_rank
    groups = Hash.new { |h, k| h[k] = [] }
    cards.each { |card| groups[card.rank] << card }

    groups.values.sort do |g0, g1|
      if g0.count == g1.count
        g1.first.compare(g0.first)
      else
        g1.count <=> g0.count
      end
    end
  end
end
