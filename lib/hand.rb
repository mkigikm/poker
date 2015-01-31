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
    if is_flush? && is_straight?
      [:straight_flush, Card.order(cards)]
    elsif is_flush? && is_straight?(true)
      [:straight_flush, Card.order(cards, true)]
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
end
