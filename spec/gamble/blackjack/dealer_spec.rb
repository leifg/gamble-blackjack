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

      describe "#hand" do
        it "is not accessible from the outside" do
          expect(subject.public_methods).not_to include(:hand)
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
