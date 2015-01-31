class Hand
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def replace(remove, add)
    unless remove.all? { |card| cards.include?(card) }
      raise "those cards aren't in the hand"
    end

    raise "must replace all the removed cards" unless remove.count == add.count

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
