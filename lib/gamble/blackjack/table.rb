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

        running_participants = participants.map(&:reset)
        running_shoe, running_participants = deal_cards(running_shoe, running_participants)

        up_card = running_participants.last.up_card

        played_participants = running_participants.map do |participant|
          possible_actions = [:hit, :stand]
          bet = participant.bet

          begin
            action = if possible_actions.size == 1
              possible_actions.first
            else
              participant.act(
                possible_actions: possible_actions,
                hand: participant.hand,
                up_card: up_card,
                shoe: running_shoe,
              )
            end
            if action == :hit || action == :double
              running_shoe, card = running_shoe.draw
              participant = participant.deal(card)
            end
          end while(action != :stand && participant.dealable?)
          [participant, bet]
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

      def deal_cards(from, to, num = 2)
        return [from, to] if num < 1

        running_players = to.map do |player|
          from, running_card = from.draw
          player.deal(running_card)
        end

        deal_cards(from, running_players, num-1)
      end

      # players + dealer
      def participants
        players + [dealer]
      end

      def self.calculate_bets(players_with_bets)
        running_dealer, _ = players_with_bets.pop
        players_with_transfers = players_with_bets.map do |player, bet|
          transfer = if player.hand.busted? || player.hand.value < running_dealer.hand.value
            bet
          elsif player.hand.value > running_dealer.hand.value
            if player.hand.blackjack?
              bet = bet * 1.5
            end
            bet * -1
          else
            0
          end
          [player, transfer]
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
