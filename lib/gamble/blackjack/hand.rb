module Gamble
  module Blackjack
    class Hand
      attr_reader :cards
      attr_reader :bet

      def initialize(cards: [], bet: 0)
        @cards = Array(cards)
        @bet = bet
      end

      def value
        cards.sort_by {|c| c.value.max}.inject(0) do |sum, card|
          if (sum + card.value.max) <= Gamble::Blackjack::MAX_VALUE
            sum + card.value.max
          else
            sum + card.value.min
          end
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

      def dealable?(max_cards)
        if busted? || cards.count >= max_cards
          false
        else
          true
        end
      end

      def possible_actions(max_cards)
        if !dealable?(max_cards)
          [:stand]
        elsif splittable?
          [:double, :hit, :split, :stand]
        elsif size < 2
          [:hit]
        elsif size == 2
          [:double, :hit, :stand]
        elsif size > 2
          [:hit, :stand]
        end
      end

      def deal(dealed_cards)
        raise RuntimeError, "Cannot deal to busted hand" if busted?

        Hand.new(cards: cards + Array(dealed_cards), bet: bet)
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
