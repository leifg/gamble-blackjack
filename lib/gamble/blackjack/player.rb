module Gamble
  module Blackjack
    class Player
      extend Forwardable

      attr_reader :hand
      attr_reader :strategy

      def_delegators :strategy, :act

      def initialize(strategy:, money:, bet:, hand: Hand.new)
        @hand = hand
        @money = money
        @bet = bet
        @strategy = Object.new.extend(strategy)
      end

      def bet(round = 0)
        if @bet.respond_to?(:call)
          @bet.call(round)
        else
          @bet
        end
      end
    end
  end
end
