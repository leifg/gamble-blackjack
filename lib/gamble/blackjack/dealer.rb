module Gamble
  module Blackjack
    class Dealer < Player
      def initialize(
        name: "Dealer",
        bankroll: 0,
        hand: Hand.new,
        strategy: Gamble::Blackjack::Strategies::DealerStrategy.new,
        bet: 0
      )
        super(
          name: name,
          strategy: strategy,
          bankroll: bankroll,
          bet: bet,
          hand: hand
        )
      end

      def max_cards
        21
      end

      def up_card
        hand.cards.first
      end
    end
  end
end
