require "spec_helper"

module Gamble
  module Blackjack
    describe Dealer do
      subject { described_class.new(hands: [hand]) }
      let(:hand) { Hand.new }

      describe "#reset" do
        let(:hand) do
          Hand.new(
            cards: [
              Card.new(:ace, :clubs),
              Card.new(:king, :spades),
            ]
          )
        end

        let(:shoe) { instance_spy("Gamble::Blackjack::Shoe") }

        it "returns dealer with empty hand" do
          dealer = subject.reset(shoe: shoe)
          expect(dealer.hands.first.cards).to be_empty
        end

        it "returns a dealer" do
          expect(subject.reset(shoe: shoe)).to be_a(Dealer)
        end
      end

      describe "#hand" do
        let(:hand) do
          Hand.new(
            cards: [
              Card.new(:ace, :clubs),
              Card.new(:king, :spades),
            ]
          )
        end

        it "returns first hand" do
          expect(subject.hand).to eq(hand)
        end
      end

      describe "#up_card" do
        let(:first_card) { Card.new(:king, :spades) }
        let(:second_card) { Card.new(:three, :hearts) }
        let(:hand) { Hand.new(cards: [first_card, second_card])}

        it "returns the first card" do
          expect(subject.up_card).to eq(first_card)
        end
      end
    end
  end
end
