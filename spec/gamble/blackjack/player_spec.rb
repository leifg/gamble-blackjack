require "spec_helper"

module Gamble
  module Blackjack
    describe Player do
      subject do
        described_class.new(
          name: name,
          strategy: strategy,
          money: money,
          bet: bet,
          hand: hand,
        )
      end

      let(:name) { "Joe" }
      let(:strategy) { double("Strategy", call: :hit) }
      let(:money) { 1000 }
      let(:bet) { 100 }
      let(:hand) { Hand.new }

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

          it "sends correct message to strategy" do
            subject.act(params)
            expect(strategy).to have_received(:call).with(params)
          end
        end
      end

      describe "#bet" do
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

      describe "#deal" do
        let(:card) { Card.new(:seven, :hearts) }

        it "returns a player" do
          expect(subject.deal(card)).to be_a(Player)
        end

        it "returns a new player" do
          expect(subject.deal(card)).not_to be_equal(subject)
        end
      end

      describe "#add_money" do
        let(:money) { 1000 }
        let(:amount) { 100 }

        let(:expected_player) do
          described_class.new(
            name: "Joe",
            strategy: strategy,
            money: (money + amount),
            bet: bet,
            hand: hand,
          )
        end

        it "returns a new player with add money" do
          expect(subject.add_money(amount)).to eq(expected_player)
        end
      end

      describe ".transfer" do
        let(:dealer) { Dealer.new }
        let(:player) { subject }
        let(:money) { 1000 }
        let(:amount) { 100 }

        it "transfers money from player to dealer" do
          new_player, new_dealer = described_class.transfer(from: player, to: dealer, amount: amount)
          expect(new_player.money).to eq(900)
          expect(new_dealer.money).to eq(100)
        end

        it "preseserves types" do
          new_player, new_dealer = described_class.transfer(from: player, to: dealer, amount: amount)
          expect(new_player).to be_a(Player)
          expect(new_dealer).to be_a(Dealer)
        end
      end
    end
  end
end
