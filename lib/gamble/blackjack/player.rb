module Gamble
  module Blackjack
    class Player
      extend Forwardable

      attr_reader :hand
      attr_reader :strategy
      attr_reader :money

      def_delegators :strategy, :act

      def initialize(strategy:, money:, bet:, hand: Hand.new)
        @hand = hand.freeze
        @money = money.freeze
        @bet = bet.freeze
        @strategy_module = strategy
      end

      def strategy
        Object.new.extend(@strategy_module).freeze
      end

      def bet(round = 0)
        if @bet.respond_to?(:call)
          @bet.call(round)
        else
          @bet
        end
      end

      def deal(*cards)
        Player.new(
          strategy: @strategy_module,
          money: money,
          bet: @bet,
          hand: hand.deal(*cards)
        )
      end
    end
  end
end
