require "spec_helper"

module Gamble
  module Blackjack
    describe Table do
      subject do
        described_class.new(players: players, shoe: shoe)
      end

      let(:players) do
        [
          double("Player", name: "Joe"),
          double("Player", name: "Stacey"),
        ]
      end

      let(:shoe) { double("Shoe") }

      describe "#dealer" do
        it "returns a dealer object" do
          expect(subject.dealer).to be_a(Dealer)
        end
      end

      describe "#next" do
        it "returns a table object" do
          expect(subject.next).to be_a(Table)
        end

        it "returns a different table object" do
          expect(subject.next).not_to be_equal(subject)
        end

        it "sets the current object as previous" do
          expect(subject.next.previous).to be_equal(subject)
        end
      end
    end
  end
end
