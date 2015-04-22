module Gamble
  module Blackjack
    class Shoe
      attr_reader :cards
      attr_reader :discard_tray

      def initialize(cards:, discard_tray: [])
        @cards = cards.freeze
        @discard_tray = discard_tray.freeze
      end

      def size
        cards.size
      end

      def draw
        new_cards = cards.last(cards.size - 1)
        drawn_card = cards.first

        [Shoe.new(cards: new_cards, discard_tray: discard_tray + [drawn_card]), cards.first]
      end

      def ==(o)
        self.class == o.class &&
        self.cards == o.cards
      end

      alias_method :eql?, :==

      def self.init_with_decks(num_of_decks)
        new(cards: num_of_decks.times.map { Deck.new.cards }.flatten.shuffle)
      end
    end
  end
end
