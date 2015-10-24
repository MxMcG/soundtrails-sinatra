require_relative "deck.rb"

class Card

  def initialize(args = {})
    @date = args[:date]
    @time = args[:time]
  end

  def dates(calender)
    @card_array << type
  end

end


test = Card.new()
test2 = Card.new()
test3 = Card.new()
test_array = []
test_array << test
test_array << test2
test_array << test3
# p test_array