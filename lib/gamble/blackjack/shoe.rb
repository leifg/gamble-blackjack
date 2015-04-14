module Gamble
  module Blackjack
    class Shoe
      attr_reader :cards

      def initialize(cards)
        @cards = cards.dup.freeze
      end

      def size
        cards.size
      end

      def draw
        [Shoe.new(cards.last(cards.size - 1)), cards.first]
      end

      def self.init_with_decks(num_of_decks)
        new(num_of_decks.times.map { Deck.new.cards }.flatten.shuffle)
      end
    end
  end
end
