require "spec_helper"

module Gamble
  module Blackjack
    describe Dealer do
      subject { described_class.new }

      describe "#deal" do
        let(:card) { Card.new(:queen, :diamonds) }

        it "returns a dealer" do
          expect(subject.deal(card)).to be_a(Dealer)
        end

        it "returns a new dealer" do
          expect(subject.deal(card).object_id).not_to eq(subject.object_id)
        end
      end
    end
  end
end
