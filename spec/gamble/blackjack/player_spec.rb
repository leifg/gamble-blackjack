require "spec_helper"

module Gamble
  module Blackjack
    describe Player do
      subject do
        described_class.new(
          name: name,
          strategy: strategy,
          bankroll: bankroll,
          bet: bet,
          hand: hand,
        )
      end

      let(:name) { "Joe" }
      let(:strategy) { double("Strategy", call: :hit) }
      let(:bankroll) { 1000 }
      let(:bet) { 100 }
      let(:hand) { Hand.new }

      include_examples "dealable hand", false

      describe "#act" do
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

        context "empty hand" do
          it "returns a player" do
            expect(subject.deal(card)).to be_a(Player)
          end

          it "returns a new player" do
            expect(subject.deal(card)).not_to be_equal(subject)
          end
        end

        context "busted hand" do
          let(:hand) do
            Hand.new(
              Card.new(:eight, :spades),
              Card.new(:nine, :diamonds),
              Card.new(:ten, :hearts)
            )
          end

          it "raises error on dealing busted hand" do
            expect { subject.deal(card) }.to raise_error(RuntimeError)
          end

        end
      end

      describe "#reset" do
        let(:hand) do
          Hand.new(
            Card.new(:eight, :spades),
            Card.new(:nine, :diamonds),
          )
        end

        it "returns player with empty hand" do
          player = subject.reset
          expect(player.hand.cards).to be_empty
        end

        it "returns a player" do
          expect(subject.reset).to be_a(Player)
        end
      end

      describe "#add_bankroll" do
        let(:bankroll) { 1000 }
        let(:amount) { 100 }

        let(:expected_player) do
          described_class.new(
            name: "Joe",
            strategy: strategy,
            bankroll: (bankroll + amount),
            bet: bet,
            hand: hand,
          )
        end

        it "returns a new player with add bankroll" do
          expect(subject.add_bankroll(amount)).to eq(expected_player)
        end
      end

      describe ".transfer" do
        let(:dealer) { Dealer.new }
        let(:player) { subject }
        let(:bankroll) { 1000 }
        let(:amount) { 100 }

        context "once" do
          it "transfers bankroll from player to dealer" do
            new_player, new_dealer = described_class.transfer(from: player, to: dealer, amount: amount)
            expect(new_player.bankroll).to eq(900)
            expect(new_dealer.bankroll).to eq(100)
          end

          it "transfers bankroll from dealer to player" do
            new_dealer, new_player = described_class.transfer(from: dealer, to: player, amount: amount)
            expect(new_player.bankroll).to eq(1100)
            expect(new_dealer.bankroll).to eq(-100)
          end

          it "preseserves types" do
            new_player, new_dealer = described_class.transfer(from: player, to: dealer, amount: amount)
            expect(new_player).to be_a(Player)
            expect(new_dealer).to be_a(Dealer)
          end
        end

        context "twice" do
          it "transfers bankroll from player to dealer" do
            new_player, new_dealer = described_class.transfer(from: player, to: dealer, amount: amount)
            new_player, new_dealer = described_class.transfer(from: new_player, to: new_dealer, amount: amount)
            expect(new_player.bankroll).to eq(800)
            expect(new_dealer.bankroll).to eq(200)
          end

          it "transfers bankroll from dealer to player" do
            new_dealer, new_player = described_class.transfer(from: dealer, to: player, amount: amount)
            new_dealer, new_player = described_class.transfer(from: new_dealer, to: new_player, amount: amount)
            expect(new_player.bankroll).to eq(1200)
            expect(new_dealer.bankroll).to eq(-200)
          end
        end
      end
    end
  end
end
