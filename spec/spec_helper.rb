require "rubygems"
require "bundler/setup"

Bundler.require :development

require "gamble/blackjack"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
