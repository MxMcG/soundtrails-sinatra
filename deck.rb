require_relative "card.rb"

class Deck

  def initialize(args = {})
    @event_dates = args[:dates]
    @event_times = args[:times]
  end

end

test_deck = Deck.new(dates: [1, 2, 3, 4], times: [5, 6, 7, 8])

test_card = Card.new(date: , time: )