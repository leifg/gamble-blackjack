require "spec_helper"

module Gamble
  module Blackjack
    describe Player do
      subject do
        described_class.new(
          name: name,
          playing_strategy: playing_strategy,
          betting_strategy: betting_strategy,
          bankroll: bankroll,
          hands: hand,
        )
      end

      let(:name) { "Joe" }
      let(:playing_strategy) { double("playing_strategy", call: :hit) }
      let(:bankroll) { 1000 }
      let(:hand) { Hand.new }
      let(:betting_strategy) { instance_spy("Proc", call: bet) }
      let(:bet) { 0 }

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

          it "sends correct message to playing_strategy" do
            subject.act(params)
            expect(playing_strategy).to have_received(:call).with(params)
          end
        end
      end

      describe "#reset" do
        let(:hand) do
          Hand.new(
            cards: [
              Card.new(:eight, :spades),
              Card.new(:nine, :diamonds),
            ]
          )
        end

        let(:shoe) { instance_spy("Gamble::Blackjack::Shoe") }

        it "returns player with empty hand" do
          player = subject.reset(shoe: shoe)
          expect(player.hands).to eq([Hand.new])
        end

        it "returns a player" do
          expect(subject.reset(shoe: shoe)).to be_a(Player)
        end
      end

      describe "#bet" do
        let(:bankroll) { 100 }
        let(:shoe) { instance_spy("Gamble::Blackjack::Shoe") }
        let(:params) { { bankroll: bankroll, shoe: shoe } }

        context "bankroll sufficient" do
          let(:bet) { 1 }

          it "returns bet" do
            expect(subject.bet(params)).to eq(bet)
          end

          it "calls betting_strategy correctly" do
            subject.bet(params)
            expect(betting_strategy).
              to have_received(:call).
              with(bankroll: bankroll, shoe: shoe)
          end
        end

        context "bankroll insufficient" do
          let(:bet) { 200 }

          it "raises error" do
            expect { subject.bet(params) }.to raise_error(InsufficientBankroll)
          end
        end
      end


      describe "#add_bankroll" do
        let(:bankroll) { 1000 }
        let(:amount) { 100 }

        let(:expected_player) do
          described_class.new(
            name: "Joe",
            playing_strategy: playing_strategy,
            betting_strategy: betting_strategy,
            bankroll: (bankroll + amount),
            hands: hand,
          )
        end

        it "returns a new player with add bankroll" do
          expect(subject.add_bankroll(amount)).to eq(expected_player)
        end
      end

      describe "#replace" do
        context "new hand" do
          let(:new_hand) do
            Hand.new(
              cards: [
                Card.new(:eight, :spades),
                Card.new(:nine, :diamonds),
              ]
            )
          end

          let(:expected_player) do
            described_class.new(
              name: name,
              playing_strategy: playing_strategy,
              betting_strategy: betting_strategy,
              bankroll: bankroll,
              hands: new_hand,
            )
          end

          it "returns a player" do
            expect(subject.replace(hands: new_hand)).to be_a(Player)
          end

          it "returns expected player" do
            expect(subject.replace(hands: new_hand)).to eq(expected_player)
          end
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
