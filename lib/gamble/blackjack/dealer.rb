module Gamble
  module Blackjack
    class Dealer < Player
      def initialize(
        name: "Dealer",
        playing_strategy: Gamble::Blackjack::Strategies::DealerStrategy.new,
        betting_strategy: proc { 0 },
        bankroll: 0,
        hand: Hand.new
      )
        super(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hand: hand
        )
      end

      def max_cards
        17
      end

      def up_card
        hand.cards.first
      end
    end
  end
end
