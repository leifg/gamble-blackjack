module Gamble
  module Blackjack
    module Strategies
      class DealerStrategy
        def call(possible_actions:, hand:, up_card:, shoe:)
          if hand.value < 17
            :hit
          else
            :stand
          end
        end
      end
    end
  end
end
