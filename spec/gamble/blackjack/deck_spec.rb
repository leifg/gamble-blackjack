require "spec_helper"

module Gamble
  module Blackjack
    describe Deck do
      subject { described_class.new }

      describe "#size" do
        its(:size) { is_expected.to eq(Gamble::Blackjack::DECK_SIZE) }
      end

      context "uniqueness" do
        it "has unique cards" do
          expect(subject.cards.uniq.size).to eq(Gamble::Blackjack::DECK_SIZE)
        end
      end
    end
  end
end
