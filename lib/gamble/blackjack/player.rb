module Gamble
  module Blackjack
    class Player
      extend Forwardable

      attr_reader :name
      attr_reader :hand
      attr_reader :strategy
      attr_reader :money

      def initialize(name:, strategy:, money:, bet:, hand: Hand.new)
        @name = name
        @hand = hand.freeze
        @money = money.freeze
        @bet = bet.freeze
        @strategy = strategy
      end

      def act(params)
        strategy.call(params)
      end

      def bet(round = 0)
        if @bet.respond_to?(:call)
          @bet.call(round)
        else
          @bet
        end
      end

      def deal(*cards)
        raise RuntimeError, "Cannot deal to busted hand" if hand.busted?

        Player.new(
          name: name,
          strategy: strategy,
          money: money,
          bet: @bet,
          hand: hand.deal(*cards)
        )
      end

      def reset
        Player.new(
          name: name,
          strategy: strategy,
          money: money,
          bet: @bet,
          hand: Hand.new
        )
      end

      def add_money(amount)
        Player.new(
          name: name,
          strategy: strategy,
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
