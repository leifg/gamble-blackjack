module Gamble
  module Blackjack
    class Player
      attr_reader :name
      attr_reader :playing_strategy
      attr_reader :betting_strategy
      attr_reader :bankroll
      attr_reader :hands

      def initialize(name:, playing_strategy:, betting_strategy:, bankroll:, hands: [])
        @name = name
        @hands = Array(hands)
        @bankroll = bankroll.freeze
        @playing_strategy = playing_strategy
        @betting_strategy = betting_strategy
      end

      def act(params)
        playing_strategy.call(params)
      end

      def bet(params)
        bet = betting_strategy.call(params)
        raise InsufficientBankroll if bet > bankroll
        bet
      end

      def replace(name: self.name, playing_strategy: self.playing_strategy, betting_strategy: self.betting_strategy, bankroll: self.bankroll, hands: self.hands)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hands: hands,
        )
      end

      def reset(shoe:)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hands: [Hand.new(bet: self.bet(bankroll: bankroll))]
        )
      end

      def add_bankroll(amount)
        self.class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll + amount,
          hands: hands,
        )
      end

      def ==(o)
        self.class == o.class &&
        self.bankroll == o.bankroll &&
        self.hands == o.hands
      end

      alias_method :eql?, :==

      def self.transfer(from:, to:, amount:)
        [from.add_bankroll(amount * -1), to.add_bankroll(amount)]
      end

      def max_cards
        5
      end
    end
  end
end
