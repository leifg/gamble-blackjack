require "spec_helper"

module Gamble
  module Blackjack
    module FirstActionStrategy
      def act(possible_actions:, upcard:, players:)
        possible_actions.first
      end
    end

    describe Player do
      subject { described_class.new(
        strategy: FirstActionStrategy,
        money: money,
        bet: bet,
      ) }

      let(:money) { 1000 }
      let(:bet) { 100 }

      describe "act" do
        let(:params) do
          {
            possible_actions: possible_actions,
            upcard: upcard,
            players: players,
          }
        end

        context "first move" do
          let(:possible_actions) { [:hit, :stand, :split] }
          let(:upcard) { Card.new(:seven, :spades) }
          let(:players) { [subject] }

          it "returns action" do
            expect(subject.act(params)).to eq(:hit)
          end
        end
      end

      describe "bet" do
        context "static bet" do
          let(:bet) { 20 }

          it "returns static bet" do
            expect(subject.bet).to eq(bet)
          end
        end

        context "variable bet" do
          let(:bet) { proc { |i| i } }

          it "returns variable bet" do
            expect(subject.bet(17)).to eq(17)
          end
        end
      end
    end
  end
end
