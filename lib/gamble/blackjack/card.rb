module Gamble
  module Blackjack
    class Card
      attr_reader :suit
      attr_reader :rank

      def initialize(rank, suit)
        @rank = self.class.validate_rank rank
        @suit = self.class.validate_suit suit
      end

      def value
        self.class.ranks_to_value[rank]
      end

      private

      def self.validate_rank(rank)
        raise ArgumentError, "Invalid Rank #{rank}" unless ranks_to_value.keys.include?(rank)
        rank
      end

      def self.validate_suit(suit)
        raise ArgumentError, "Invalid Suit #{suit}" unless suits.include?(suit)
        suit
      end

      def self.ranks_to_value
        @@_ranks ||= {
          ace: [1,11],
          two: [2],
          three: [3],
          four: [4],
          five: [5],
          six: [6],
          seven: [7],
          eight: [8],
          nine: [9],
          ten: [10],
          jack: [10],
          queen: [10],
          king: [10],
        }
      end

      def self.suits
        @@_suits ||= [:clubs, :diamonds, :hearts, :spades]
      end
    end
  end
end
