module Gamble
  module Blackjack
    class Deck
      attr_reader :cards

      def initialize
        @cards = []

        [:ace, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten, :jack, :queen, :king].each do |rank|
          [:clubs, :diamonds, :hearts, :spades].each do |suit|
            @cards << Card.new(rank, suit)
          end
        end
      end

      def size
        cards.size
      end
    end
  end
end
