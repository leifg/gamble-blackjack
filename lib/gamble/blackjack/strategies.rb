module Gamble
  module Blackjack
    module Strategies
      module DealerStrategy
        def act(possible_actions:, hand:, table:)
          possible_actions.first
        end
      end
    end
  end
end
