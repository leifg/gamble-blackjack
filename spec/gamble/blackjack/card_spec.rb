require "spec_helper"

module Gamble
  module Blackjack
    describe Card do

      describe "#initialize" do
        subject { described_class.new(rank, suit) }
        let(:rank) { :eight }
        let(:suit) { :diamonds }


        context "valid" do
          it "does not raise an error for a valid card" do
            expect { subject }.not_to raise_error
          end
        end

        context "invalid" do
          context "invalid rank" do
            let(:rank) { :eleven }

            it "raises an ArgumentError" do
              expect { subject }.to raise_error(ArgumentError)
            end
          end

          context "invalid suit" do
            let(:suit) { :purple }

            it "raises an ArgumentError" do
              expect { subject }.to raise_error(ArgumentError)
            end
          end
        end
      end

      describe "#value" do
        context "number Card" do
          subject { described_class.new(:seven, :hearts) }

          it "returns [7]" do
            expect(subject.value).to eq([7])
          end
        end

        context "pitcher card" do
          subject { described_class.new(:king, :clubs) }

          it "returns [10]" do
            expect(subject.value).to eq([10])
          end
        end

        context "ace Card" do
          subject { described_class.new(:ace, :spades) }

          it "returns [1,11]" do
            expect(subject.value).to eq([1,11])
          end
        end
      end
    end
  end
end
