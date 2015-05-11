shared_examples "dealable hand" do
  describe "#dealable?" do
    context "empty hand" do
      let(:cards) { [] }

      it "returns true" do
        expect(subject.dealable?(max_cards)).to be(true)
      end
    end

    context "busted hand" do
      let(:cards) do
        [
          Gamble::Blackjack::Card.new(:king, :hearts),
          Gamble::Blackjack::Card.new(:five, :spades),
          Gamble::Blackjack::Card.new(:seven, :diamonds),
        ]
      end

      it "returns false" do
        expect(subject.dealable?(max_cards)).to be(false)
      end
    end

    context "already 5 cards" do
      let(:cards) do
        [
          Gamble::Blackjack::Card.new(:ace, :hearts),
          Gamble::Blackjack::Card.new(:five, :spades),
          Gamble::Blackjack::Card.new(:three, :diamonds),
          Gamble::Blackjack::Card.new(:two, :clubs),
          Gamble::Blackjack::Card.new(:six, :hearts),
        ]
      end

      it "returns false" do
        expect(subject.dealable?(max_cards)).to be(can_deal_more)
      end
    end
  end
end
