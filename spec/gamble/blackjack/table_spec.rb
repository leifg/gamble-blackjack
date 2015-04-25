require "spec_helper"

module Gamble
  module Blackjack
    describe Table do
      subject do
        described_class.new(players: players, shoe: shoe)
      end

      describe "#next" do
        before do
          allow(player).to receive(:act).and_return(:stand)
        end

        let(:strategy) { proc { :stand } }

        let(:player) do
          Player.new(name: "Alice", strategy: strategy, money: 100, bet: 1)
        end

        let(:players) { [ player ] }

        let(:shoe) do
          Shoe.new(cards: [
            Card.new(:ace, :hearts),
            Card.new(:two, :hearts),
            Card.new(:three, :hearts),
            Card.new(:four, :hearts),
            Card.new(:five, :hearts),
            Card.new(:six, :hearts),
            Card.new(:seven, :hearts),
            Card.new(:eight, :hearts),
            Card.new(:nine, :hearts),
            Card.new(:ten, :hearts),
            Card.new(:jack, :hearts),
            Card.new(:queen, :hearts),
            Card.new(:king, :hearts),
            Card.new(:ace, :spades),
            Card.new(:two, :spades),
            Card.new(:three, :spades),
            Card.new(:four, :spades),
            Card.new(:five, :spades),
            Card.new(:six, :spades),
            Card.new(:seven, :spades),
            Card.new(:eight, :spades),
            Card.new(:nine, :spades),
            Card.new(:ten, :spades),
            Card.new(:jack, :spades),
            Card.new(:queen, :spades),
            Card.new(:king, :spades),
          ])
        end

        context "1 round" do
          let(:expected_table) do
            described_class.new(
              players: expected_players,
              shoe: expected_shoe,
              dealer: expected_dealer,
              round: expected_round,
              previous: subject,
            )
          end

          let(:expected_players) do
            [
              Player.new(
                name: "Alice",
                strategy: strategy,
                money: 99,
                bet: 1,
                hand: Hand.new(
                  Card.new(:two, :hearts),
                  Card.new(:four, :hearts),
                )
              ),
            ]
          end

          let(:expected_shoe) do
            Shoe.new(cards: [
              Card.new(:eight, :hearts),
              Card.new(:nine, :hearts),
              Card.new(:ten, :hearts),
              Card.new(:jack, :hearts),
              Card.new(:queen, :hearts),
              Card.new(:king, :hearts),
              Card.new(:ace, :spades),
              Card.new(:two, :spades),
              Card.new(:three, :spades),
              Card.new(:four, :spades),
              Card.new(:five, :spades),
              Card.new(:six, :spades),
              Card.new(:seven, :spades),
              Card.new(:eight, :spades),
              Card.new(:nine, :spades),
              Card.new(:ten, :spades),
              Card.new(:jack, :spades),
              Card.new(:queen, :spades),
              Card.new(:king, :spades),
            ],
            discard_tray: [
              Card.new(:ace, :hearts),
              Card.new(:two, :hearts),
              Card.new(:three, :hearts),
              Card.new(:four, :hearts),
              Card.new(:five, :hearts),
              Card.new(:six, :hearts),
              Card.new(:seven, :hearts),
            ])
          end

          let(:expected_dealer) do
            Dealer.new(
              money: 1,
              hand: Hand.new(
                Card.new(:three, :hearts),
                Card.new(:five, :hearts),
                Card.new(:six, :hearts),
                Card.new(:seven, :hearts),
              )
            )
          end

          let(:expected_round) { 1 }

          it "returns a table object" do
            expect(subject.next).to be_a(Table)
          end

          it "returns a different table object" do
            expect(subject.next).not_to be_equal(subject)
          end

          it "sets the current object as previous" do
            expect(subject.next.previous).to be_equal(subject)
          end

          it "returns correct table" do
            expect(subject.next).to eq(expected_table)
          end
        end

        context "2 rounds" do
          it "correctly removes money from players" do
            table = subject.next
            table = table.next
            expect(table.players.first.money).to eq(98)
          end

          it "correctly adds money to dealer" do
            table = subject.next
            table = table.next
            expect(table.dealer.money).to eq(2)
          end
        end
      end
    end
  end
end
