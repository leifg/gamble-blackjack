# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gamble/blackjack/version"

Gem::Specification.new do |spec|
  spec.name          = "gamble-blackjack"
  spec.version       = Gamble::Blackjack::VERSION
  spec.authors       = ["Leif Gensert"]
  spec.email         = ["leif@gensert.de"]

  spec.summary       = %q{Blackjack Simulation built in Ruby}
  spec.description   = %q{Want to simulate games in Blackjack? Use this framework.}
  spec.homepage      = "http://leifg.ghost.io"

  # Prevent pushing this gem to RubyGems.org by setting "allowed_push_host", or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry"
end
