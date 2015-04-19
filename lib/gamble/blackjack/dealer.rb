module Gamble
  module Blackjack
    class Dealer < Player
      def initialize(hand: Hand.new)
        super(
          name: "Dealer",
          strategy: Gamble::Blackjack::Strategies::DealerStrategy,
          money: 0,
          bet: 0,
          hand: hand
        )
      end

      def deal(*cards)
        Dealer.new(hand: hand.deal(*cards))
      end

      def up_card
        hand.cards.first
      end

      private

      attr_reader :hand
    end
  end
end
