module Gamble
  module Blackjack
    class Table
      attr_reader :players
      attr_reader :shoe
      attr_reader :previous
      attr_reader :dealer

      def initialize(players:, shoe:, dealer: Dealer.new, previous: nil)
        @players = players
        @shoe = shoe
        @previous = previous
        @dealer = dealer
      end

      def next
        Table.new(players: players, shoe: shoe, dealer: dealer, previous: self)
      end
    end
  end
end
