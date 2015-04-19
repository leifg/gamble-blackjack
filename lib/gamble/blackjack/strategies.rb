module Gamble
  module Blackjack
    module Strategies
      module DealerStrategy
        def act(possible_actions:, hand:, up_card:)
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
