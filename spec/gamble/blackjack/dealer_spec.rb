require "spec_helper"

module Gamble
  module Blackjack
    describe Dealer do
      subject { described_class.new(hand: hand) }
      let(:hand) { Hand.new }

      describe "#deal" do
        let(:card) { Card.new(:queen, :diamonds) }

        it "returns a dealer" do
          expect(subject.deal(card)).to be_a(Dealer)
        end

        it "returns a new dealer" do
          expect(subject.deal(card).object_id).not_to eq(subject.object_id)
        end
      end

      include_examples "dealable hand", true

      describe "#reset" do
        let(:hand) do
          Hand.new(
            Card.new(:ace, :clubs),
            Card.new(:king, :spades),
          )
        end

        it "returns dealer with empty hand" do
          dealer = subject.reset
          expect(dealer.hand.cards).to be_empty
        end

        it "returns a dealer" do
          expect(subject.reset).to be_a(Dealer)
        end
      end

      describe "#up_card" do
        let(:first_card) { Card.new(:king, :spades) }
        let(:second_card) { Card.new(:three, :hearts) }
        let(:hand) { Hand.new(first_card, second_card)}

        it "returns the first card" do
          expect(subject.up_card).to eq(first_card)
        end
      end
    end
  end
end
