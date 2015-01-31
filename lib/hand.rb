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
end
