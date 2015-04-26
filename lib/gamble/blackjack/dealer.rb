module Gamble
  module Blackjack
    class Dealer < Player
      def initialize(bankroll: 0, hand: Hand.new)
        super(
          name: "Dealer",
          strategy: Gamble::Blackjack::Strategies::DealerStrategy.new,
          bankroll: bankroll,
          bet: 0,
          hand: hand
        )
      end

      def deal(*cards)
        Dealer.new(hand: hand.deal(*cards), bankroll: bankroll)
      end

      def reset
        Dealer.new(bankroll: bankroll)
      end

      def add_bankroll(amount)
        Dealer.new(hand: hand, bankroll: bankroll + amount)
      end

      def up_card
        hand.cards.first
      end
    end
  end
end
