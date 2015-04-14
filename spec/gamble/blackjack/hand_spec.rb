require "spec_helper"

module Gamble
  module Blackjack
    describe Hand do
      subject { described_class.new(*cards) }

      context "hands at beginning" do
        context "hard hand" do
          let(:cards) { [ Card.new(:seven, :clubs), Card.new(:eight, :hearts) ] }

          its(:value) { is_expected.to eq(15) }
          it { is_expected.not_to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "soft hand" do
          let(:cards) { [ Card.new(:ace, :hearts), Card.new(:two, :clubs) ] }

          its(:value) { is_expected.to eq(13) }
          it { is_expected.not_to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "pair hand" do
          let(:cards) { [ Card.new(:three, :clubs), Card.new(:three, :hearts) ] }

          its(:value) { is_expected.to eq(6) }
          it { is_expected.to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "two face cards" do
          let(:cards) { [ Card.new(:queen, :clubs), Card.new(:jack, :hearts) ] }

          its(:value) { is_expected.to eq(20) }
          it { is_expected.to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "two aces" do
          let(:cards) { [ Card.new(:ace, :clubs), Card.new(:ace, :hearts) ] }

          its(:value) { is_expected.to eq(12) }
          it { is_expected.to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "blackjack" do
          let(:cards) { [ Card.new(:ace, :clubs), Card.new(:ten, :hearts) ] }

          its(:value) { is_expected.to eq(21) }
          it { is_expected.not_to be_splittable }
          it { is_expected.to be_blackjack }
          it { is_expected.not_to be_busted }
        end
      end

      context "hands in game" do
        context "regular hand" do
          let(:cards) do
            [
              Card.new(:queen, :clubs),
              Card.new(:three, :hearts),
              Card.new(:five, :diamonds),
            ]
          end

          its(:value) { is_expected.to eq(18) }
          it { is_expected.not_to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end

        context "busted hand" do
          let(:cards) do
            [
              Card.new(:queen, :clubs),
              Card.new(:eight, :hearts),
              Card.new(:five, :diamonds),
            ]
          end

          its(:value) { is_expected.to eq(23) }
          it { is_expected.not_to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.to be_busted }
        end
      end

      describe "#deal" do
        context "regular hand" do
          let(:cards) { [Card.new(:seven, :clubs), Card.new(:eight, :hearts)] }
          let(:card) { Card.new(:three, :hearts) }
          let(:expected_hand) do
            described_class.new(
              Card.new(:seven, :clubs),
              Card.new(:eight, :hearts),
              Card.new(:three, :hearts),
            )
          end

          it "returns correct hand" do
            expect(subject.deal(card)).to eq(expected_hand)
          end
        end
      end
    end
  end
end
