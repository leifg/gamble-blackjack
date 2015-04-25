module Gamble
  module Blackjack
    class Dealer < Player
      def initialize(money: 0, hand: Hand.new)
        super(
          name: "Dealer",
          strategy: Gamble::Blackjack::Strategies::DealerStrategy.new,
          money: money,
          bet: 0,
          hand: hand
        )
      end

      def deal(*cards)
        Dealer.new(hand: hand.deal(*cards), money: money)
      end

      def reset
        Dealer.new(money: money)
      end

      def add_money(amount)
        Dealer.new(hand: hand, money: money + amount)
      end

      def up_card
        hand.cards.first
      end
    end
  end
end
