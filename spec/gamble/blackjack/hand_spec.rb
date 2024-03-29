require "spec_helper"

module Gamble
  module Blackjack
    describe Hand do
      subject { described_class.new(cards: cards, bet: bet) }
      let(:bet) { 0 }

      context "dealer hand" do
        let(:max_cards) { 17 }
        let(:can_deal_more) { true }
        include_examples "dealable hand"
      end

      context "player hand" do
        let(:max_cards) { 5 }
        let(:can_deal_more) { false }
        include_examples "dealable hand"
      end

      context "empty hand" do
        let(:cards) { nil }

        its(:value) { is_expected.to eq(0) }
        it { is_expected.not_to be_splittable }
        it { is_expected.not_to be_blackjack }
        it { is_expected.not_to be_busted }
      end

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

        context "two pitcher cards" do
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

        context "high hand with ace" do
          let(:cards) do
            [
              Card.new(:ace, :hearts),
              Card.new(:five, :spades),
              Card.new(:three, :diamonds),
              Card.new(:two, :clubs),
              Card.new(:six, :hearts),
            ]
          end

          its(:value) { is_expected.to eq(17) }
          it { is_expected.not_to be_splittable }
          it { is_expected.not_to be_blackjack }
          it { is_expected.not_to be_busted }
        end
      end

      describe "#deal" do
        let(:card) { Card.new(:three, :hearts) }

        context "regular hand" do
          let(:cards) { [Card.new(:seven, :clubs), Card.new(:eight, :hearts)] }
          let(:expected_hand) do
            described_class.new(
              cards: [
                Card.new(:seven, :clubs),
                Card.new(:eight, :hearts),
                Card.new(:three, :hearts),
              ],
              bet: bet,
            )
          end

          it "returns correct hand" do
            expect(subject.deal(card)).to eq(expected_hand)
          end
        end

        context "busted hand" do
          let(:cards) do
            [
              Card.new(:eight, :spades),
              Card.new(:nine, :diamonds),
              Card.new(:ten, :hearts),
            ]
          end

          it "raises error on dealing busted hand" do
            expect { subject.deal(card) }.to raise_error(RuntimeError)
          end
        end
      end

      describe "#possible_actions" do
        let(:max_cards) { 5 }

        context "empty hand" do
          let(:cards) { [] }

          it "returns :hit" do
            expect(subject.possible_actions(max_cards)).to eq([:hit])
          end
        end

        context "1 card hand" do
          let(:cards) { [Card.new(:seven, :hearts)] }

          it "returns :hit" do
            expect(subject.possible_actions(max_cards)).to eq([:hit])
          end
        end

        context "2 cards hand" do
          let(:cards) do
            [
              Card.new(:seven, :hearts),
              Card.new(:eight, :diamonds),
            ]
          end

          it "returns :double, :hit, :stand" do
            expect(subject.possible_actions(max_cards)).to eq([:double, :hit, :stand])
          end
        end

        context "3 cards hand" do
          let(:cards) do
            [
              Card.new(:seven, :hearts),
              Card.new(:eight, :diamonds),
              Card.new(:ace, :spades),
            ]
          end

          it "returns :hit, :stand" do
            expect(subject.possible_actions(max_cards)).to eq([:hit, :stand])
          end
        end

        context "5 cards hand" do
          let(:cards) do
            [
              Card.new(:four, :hearts),
              Card.new(:eight, :diamonds),
              Card.new(:ace, :spades),
              Card.new(:two, :spades),
              Card.new(:three, :spades),
            ]
          end

          it "returns :stand" do
            expect(subject.possible_actions(max_cards)).to eq([:stand])
          end
        end

        context "splittable hand" do
          let(:cards) do
            [
              Card.new(:seven, :hearts),
              Card.new(:seven, :diamonds),
            ]
          end

          it "returns :double, :hit, :split, :stand" do
            expect(subject.possible_actions(max_cards)).to eq([:double, :hit, :split, :stand])
          end
        end
      end

      describe "#size" do
        let(:cards) do
          [
            Card.new(:queen, :clubs),
            Card.new(:eight, :hearts),
            Card.new(:five, :diamonds),
          ]
        end

        its(:size) { is_expected.to eq(3) }
      end
    end
  end
end
