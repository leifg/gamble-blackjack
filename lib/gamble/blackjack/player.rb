module Gamble
  module Blackjack
    class Player
      extend Forwardable

      attr_reader :name
      attr_reader :hand
      attr_reader :strategy
      attr_reader :bankroll

      def initialize(name:, strategy:, bankroll:, bet:, hand: Hand.new)
        @name = name
        @hand = hand.freeze
        @bankroll = bankroll.freeze
        @bet = bet.freeze
        @strategy = strategy
      end

      def dealable?
        if hand.busted? || hand.cards.count >= max_cards
          false
        else
          true
        end
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

        self.class.new(
          name: name,
          strategy: strategy,
          bankroll: bankroll,
          bet: @bet,
          hand: hand.deal(*cards)
        )
      end

      def reset
        self.class.new(
          name: name,
          strategy: strategy,
          bankroll: bankroll,
          bet: @bet,
          hand: Hand.new
        )
      end

      def add_bankroll(amount)
        self.class.new(
          name: name,
          strategy: strategy,
          bankroll: bankroll + amount,
          bet: @bet,
          hand: hand
        )
      end

      def possible_actions
        if !dealable?
          [:stand]
        elsif hand.splittable?
          [:double, :hit, :split, :stand]
        elsif hand.size == 2
          [:double, :hit, :stand]
        elsif hand.size > 2
          [:hit, :stand]
        end
      end

      def ==(o)
        self.class == o.class &&
        @strategy_module == o.instance_variable_get("@strategy_module") &&
        self.bankroll == o.bankroll &&
        self.bet == o.bet &&
        self.hand == o.hand
      end

      alias_method :eql?, :==

      def self.transfer(from:, to:, amount:)
        [from.add_bankroll(amount * -1), to.add_bankroll(amount)]
      end

      private

      def max_cards
        5
      end
    end
  end
end
