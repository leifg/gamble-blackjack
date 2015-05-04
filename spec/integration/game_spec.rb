require "spec_helper"

describe "Default Game", type: :integration do
  let(:table) { Gamble::Blackjack::Table.new(players: players, shoe: shoe) }
  let(:shoe) do
    Gamble::Blackjack::Shoe.new(cards: [
      Gamble::Blackjack::Card.new(:ace, :hearts),
      Gamble::Blackjack::Card.new(:two, :hearts),
      Gamble::Blackjack::Card.new(:three, :hearts),
      Gamble::Blackjack::Card.new(:four, :hearts),
      Gamble::Blackjack::Card.new(:five, :hearts),
      Gamble::Blackjack::Card.new(:six, :hearts),
      Gamble::Blackjack::Card.new(:seven, :hearts),
      Gamble::Blackjack::Card.new(:eight, :hearts),
      Gamble::Blackjack::Card.new(:nine, :hearts),
      Gamble::Blackjack::Card.new(:ten, :hearts),
      Gamble::Blackjack::Card.new(:jack, :hearts),
      Gamble::Blackjack::Card.new(:queen, :hearts),
      Gamble::Blackjack::Card.new(:king, :hearts),
      Gamble::Blackjack::Card.new(:ace, :spades),
      Gamble::Blackjack::Card.new(:two, :spades),
      Gamble::Blackjack::Card.new(:three, :spades),
      Gamble::Blackjack::Card.new(:four, :spades),
      Gamble::Blackjack::Card.new(:five, :spades),
      Gamble::Blackjack::Card.new(:six, :spades),
      Gamble::Blackjack::Card.new(:seven, :spades),
      Gamble::Blackjack::Card.new(:eight, :spades),
      Gamble::Blackjack::Card.new(:nine, :spades),
      Gamble::Blackjack::Card.new(:ten, :spades),
      Gamble::Blackjack::Card.new(:jack, :spades),
      Gamble::Blackjack::Card.new(:queen, :spades),
      Gamble::Blackjack::Card.new(:king, :spades),
    ])
  end


  context "1 Player" do
    let(:player) do
      Gamble::Blackjack::Player.new(name: "Alice", strategy: strategy, bankroll: 100, bet: 1)
    end
    let(:players) { [ player ] }

    context "Player always stands" do
      let(:strategy) { proc { :stand } }

      context "1 round" do
        let(:expected_table) do
          Gamble::Blackjack::Table.new(
            players: expected_players,
            shoe: expected_shoe,
            dealer: expected_dealer,
            round: expected_round,
            previous: table,
          )
        end

        let(:expected_players) do
          [
            Gamble::Blackjack::Player.new(
              name: "Alice",
              strategy: strategy,
              bankroll: 99,
              bet: 1,
              hand: Gamble::Blackjack::Hand.new(
                Gamble::Blackjack::Card.new(:two, :hearts),
                Gamble::Blackjack::Card.new(:four, :hearts),
              )
            ),
          ]
        end

        let(:expected_shoe) do
          Gamble::Blackjack::Shoe.new(cards: [
            Gamble::Blackjack::Card.new(:eight, :hearts),
            Gamble::Blackjack::Card.new(:nine, :hearts),
            Gamble::Blackjack::Card.new(:ten, :hearts),
            Gamble::Blackjack::Card.new(:jack, :hearts),
            Gamble::Blackjack::Card.new(:queen, :hearts),
            Gamble::Blackjack::Card.new(:king, :hearts),
            Gamble::Blackjack::Card.new(:ace, :spades),
            Gamble::Blackjack::Card.new(:two, :spades),
            Gamble::Blackjack::Card.new(:three, :spades),
            Gamble::Blackjack::Card.new(:four, :spades),
            Gamble::Blackjack::Card.new(:five, :spades),
            Gamble::Blackjack::Card.new(:six, :spades),
            Gamble::Blackjack::Card.new(:seven, :spades),
            Gamble::Blackjack::Card.new(:eight, :spades),
            Gamble::Blackjack::Card.new(:nine, :spades),
            Gamble::Blackjack::Card.new(:ten, :spades),
            Gamble::Blackjack::Card.new(:jack, :spades),
            Gamble::Blackjack::Card.new(:queen, :spades),
            Gamble::Blackjack::Card.new(:king, :spades),
          ],
          discard_tray: [
            Gamble::Blackjack::Card.new(:ace, :hearts),
            Gamble::Blackjack::Card.new(:two, :hearts),
            Gamble::Blackjack::Card.new(:three, :hearts),
            Gamble::Blackjack::Card.new(:four, :hearts),
            Gamble::Blackjack::Card.new(:five, :hearts),
            Gamble::Blackjack::Card.new(:six, :hearts),
            Gamble::Blackjack::Card.new(:seven, :hearts),
          ])
        end

        let(:expected_dealer) do
          Gamble::Blackjack::Dealer.new(
            bankroll: 1,
            hand: Gamble::Blackjack::Hand.new(
              Gamble::Blackjack::Card.new(:three, :hearts),
              Gamble::Blackjack::Card.new(:five, :hearts),
              Gamble::Blackjack::Card.new(:six, :hearts),
              Gamble::Blackjack::Card.new(:seven, :hearts),
            )
          )
        end

        let(:expected_round) { 1 }

        it "returns a table object" do
          expect(table.next).to be_a(Gamble::Blackjack::Table)
        end

        it "returns a different table object" do
          expect(table.next).not_to be(table)
        end

        it "sets the current object as previous" do
          expect(table.next.previous).to be(table)
        end

        it "returns correct table" do
          expect(table.next).to eq(expected_table)
        end
      end
    end
  end
end
