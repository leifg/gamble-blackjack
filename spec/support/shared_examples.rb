shared_examples "dealable hand" do |can_deal_more|
  describe "#dealable?" do
    context "empty hand" do
      let(:hand) { Gamble::Blackjack::Hand.new }

      it "returns true" do
        expect(subject.dealable?).to be(true)
      end
    end

    context "busted hand" do
      let(:hand) do
        Gamble::Blackjack::Hand.new(
          Gamble::Blackjack::Card.new(:king, :hearts),
          Gamble::Blackjack::Card.new(:five, :spades),
          Gamble::Blackjack::Card.new(:seven, :diamonds),
        )
      end

      it "returns false" do
        expect(subject.dealable?).to be(false)
      end
    end

    context "already 5 cards" do
      let(:hand) do
        Gamble::Blackjack::Hand.new(
          Gamble::Blackjack::Card.new(:ace, :hearts),
          Gamble::Blackjack::Card.new(:five, :spades),
          Gamble::Blackjack::Card.new(:three, :diamonds),
          Gamble::Blackjack::Card.new(:two, :clubs),
          Gamble::Blackjack::Card.new(:six, :hearts),
        )
      end

      it "returns false" do
        expect(subject.dealable?).to be(can_deal_more)
      end
    end
  end
end
