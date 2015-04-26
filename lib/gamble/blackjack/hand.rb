module Gamble
  module Blackjack
    class Hand
      attr_reader :cards

      def initialize(*cards)
        @cards = cards
      end

      def value
        return 0 if cards.nil? || cards.empty?
        min_sum = cards.map{|c| c.value.min}.inject(&:+)
        max_sum = cards.map{|c| c.value.max}.inject(&:+)

        if max_sum > Gamble::Blackjack::MAX_VALUE
          min_sum
        else
          max_sum
        end
      end

      def splittable?
        cards.size == 2 && cards.map(&:value).uniq.size == 1
      end

      def blackjack?
        cards.size == 2 && value == Gamble::Blackjack::MAX_VALUE
      end

      def busted?
        value > Gamble::Blackjack::MAX_VALUE
      end

      def deal(*dealed_cards)
        Hand.new(*(cards + dealed_cards))
      end

      def size
        cards.size
      end

      def ==(o)
        self.class == o.class &&
        self.cards == o.cards
      end

      alias_method :eql?, :==
    end
  end
end
