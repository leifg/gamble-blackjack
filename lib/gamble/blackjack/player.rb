module Gamble
  module Blackjack
    class Player
      attr_reader :name
      attr_reader :playing_strategy
      attr_reader :betting_strategy
      attr_reader :bankroll
      attr_reader :hand

      def initialize(name:, playing_strategy:, betting_strategy:, bankroll:, hand: Hand.new)
        @name = name
        @hand = hand.freeze
        @bankroll = bankroll.freeze
        @playing_strategy = playing_strategy
        @betting_strategy = betting_strategy
      end

      def dealable?
        if hand.busted? || hand.cards.count >= max_cards
          false
        else
          true
        end
      end

      def act(params)
        playing_strategy.call(params)
      end

      def bet(params)
        bet = betting_strategy.call(params)
        raise InsufficientBankroll if bet > bankroll
        bet
      end

      def deal(*cards)
        raise RuntimeError, "Cannot deal to busted hand" if hand.busted?

        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hand: hand.deal(*cards)
        )
      end

      def replace(name: self.hand, playing_strategy: self.playing_strategy, betting_strategy: self.betting_strategy, bankroll: self.bankroll, hand: self.hand)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hand: hand,
        )
      end

      def reset(shoe:)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hand: Hand.new(bet: self.bet(bankroll: bankroll, ))
        )
      end

      def add_bankroll(amount)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll + amount,
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
        self.bankroll == o.bankroll &&
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
