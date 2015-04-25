require "bundler/gem_tasks"
require "gamble/blackjack"

task :gamble do
  player = Gamble::Blackjack::Player.new(name: "Leif", strategy: Gamble::Blackjack::Strategies::DealerStrategy.new, money: 5000, bet: 10)
  shoe = Gamble::Blackjack::Shoe.init_with_decks(1)
  table = Gamble::Blackjack::Table.new(players: [player], shoe: shoe)
  n = 0
  while n < 100
    n += 1
    table = table.next
  end

  puts "Money Player: #{table.players.first.money}"
  puts "Money Dealer: #{table.dealer.money}"
end
