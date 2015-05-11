module Gamble
  module Blackjack
    class Table
      attr_reader :players
      attr_reader :shoe
      attr_reader :previous
      attr_reader :dealer
      attr_reader :round

      def initialize(players:, shoe:, dealer: Dealer.new, round: 0, previous: nil)
        @players = players.freeze
        @shoe = shoe.freeze
        @previous = previous.freeze
        @dealer = dealer.freeze
        @round = round
      end

      def next
        # reshuffle when shoe has less than 10 cards
        if shoe.size < 10
          running_shoe, _ = shoe.reset.draw
        else
          running_shoe = shoe
        end

        if round == 0
          # burn card
          running_shoe, _ = shoe.draw
        end

        running_participants = participants.map{|p| p.reset(shoe: running_shoe)}

        2.times do
          running_participants = running_participants.map do |participant|
            new_hands = participant.hands.map do |hand|
              running_shoe, card = running_shoe.draw
              hand.deal(card)
            end

            participant.replace(hands: new_hands)
          end
        end

        up_card = running_participants.last.up_card

        played_participants = running_participants.map do |participant|
          new_hands = participant.hands.map do |hand|
            possible_actions = hand.possible_actions(participant.max_cards)
            begin
              action = if possible_actions.size == 1
                possible_actions.first
              else
                participant.act(
                  possible_actions: possible_actions,
                  hand: hand,
                  up_card: up_card,
                  shoe: running_shoe,
                )
              end
              raise "Illegal action #{action}. Available Actions: #{possible_actions.inspect}" unless possible_actions.include?(action)
              if action == :hit || action == :double
                running_shoe, card = running_shoe.draw
                hand = hand.deal(card)
              end
            end while(action == :hit && hand.dealable?(participant.max_cards))
            hand
          end

          participant.replace(hands: new_hands)
        end

        result_dealer, result_players = self.class.calculate_bets(played_participants)
        Table.new(players: result_players, shoe: running_shoe, dealer: result_dealer, round: round + 1, previous: self)
      end

      def ==(o)
        self.class == o.class &&
        self.players == o.players &&
        self.shoe == o.shoe &&
        self.dealer == o.dealer &&
        self.round == o.round
      end

      alias_method :eql?, :==

      private

      # players + dealer
      def participants
        players + [dealer]
      end

      def self.calculate_bets(players)
        running_dealer, _ = players.pop
        players_with_transfers = players.map do |player|
          transfer_sum = player.hands.inject(0) do |sum, hand|
            sum += if hand.busted? || hand.value < running_dealer.hand.value
              hand.bet
            elsif hand.value > hand.value
              if player.hand.blackjack?
                hand.bet * 1.5
              end
              hand.bet * -1
            else
              0
            end
          end
          [player, transfer_sum]
        end

        result_players = []

        players_with_transfers.each do |player, transfer|
          tmp_player, running_dealer = Player.transfer(from: player, to: running_dealer, amount: transfer)
          result_players << tmp_player
        end

        [running_dealer, result_players]
      end
    end
  end
end
