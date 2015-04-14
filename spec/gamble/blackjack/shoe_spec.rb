require "spec_helper"

module Gamble
  module Blackjack
    describe Shoe do
      describe "#draw" do
        subject { described_class.new(cards) }
        let(:cards) do
          [
            Card.new(:ace, :hearts),
            Card.new(:two, :hearts),
            Card.new(:three, :hearts),
            Card.new(:four, :hearts),
          ]
        end

        it "returns new shoe and a card" do
          shoe, card = subject.draw
          expect(shoe).to be_a(Shoe)
          expect(card).to be_a(Card)
        end

        it "returns a shoe with one card less" do
          shoe, _ = subject.draw
          expect(shoe.size).to eq(cards.count - 1)
        end

        it "returns the first card" do
          _, card = subject.draw
          expect(card).to eq(Card.new(:ace, :hearts))
        end
      end

      describe ".init_with_decks" do
        subject { described_class.init_with_decks(deck_count) }
        let(:deck_count) { 8 }

        its(:size) { is_expected.to eq(Gamble::Blackjack::DECK_SIZE * 8) }

        it "has #{Gamble::Blackjack::DECK_SIZE} unique cards" do
          expect(subject.cards.uniq.size).to eq(Gamble::Blackjack::DECK_SIZE)
        end
      end
    end
  end
end
