require "spec_helper"

module Gamble
  module Blackjack
    describe Shoe do
      describe "#draw" do
        subject { described_class.new(cards: cards) }
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

        it "sets new shoes first card to second card" do
          shoe, _ = subject.draw
          expect(shoe.cards.first).to eq(Card.new(:two, :hearts))
        end

        it "puts card in the discard tray" do
          shoe, card = subject.draw
          expect(shoe.discard_tray).to eq([card])
        end

        it "raises error on drawing from empty shoe" do
          shoe = subject
          shoe.cards.size.times{ shoe, _ = shoe.draw }
          expect { shoe.draw }.to raise_error(RuntimeError)
        end
      end

      describe "#reset" do
        subject { described_class.new(cards: cards, discard_tray: discared_cards) }

        let(:cards) do
          [
            Card.new(:ace, :hearts),
            Card.new(:two, :hearts),
          ]
        end

        let(:discared_cards) do
          [
            Card.new(:three, :hearts),
            Card.new(:four, :hearts),
          ]
        end

        it "empties discard tray" do
          expect(subject.reset.discard_tray).to be_empty
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
