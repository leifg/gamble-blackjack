module Gamble
  module Blackjack
    class Player
      extend Forwardable

      attr_reader :name
      attr_reader :hand
      attr_reader :strategy
      attr_reader :money

      def_delegators :strategy, :act

      def initialize(name:, strategy:, money:, bet:, hand: Hand.new)
        @name = name
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
          name: name,
          strategy: @strategy_module,
          money: money,
          bet: @bet,
          hand: hand.deal(*cards)
        )
      end

      def add_money(amount)
        Player.new(
          name: name,
          strategy: @strategy_module,
          money: money + amount,
          bet: @bet,
          hand: hand
        )
      end

      def ==(o)
        self.class == o.class &&
        @strategy_module == o.instance_variable_get("@strategy_module") &&
        self.money == o.money &&
        self.bet == o.bet &&
        self.hand == o.hand
      end

      alias_method :eql?, :==

      def self.transfer(from:, to:, amount:)
        [from.add_money(amount * -1), to.add_money(amount)]
      end
    end
  end
end
