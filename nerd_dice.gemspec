# frozen_string_literal: true

require_relative "lib/nerd_dice/version"

Gem::Specification.new do |spec|
  spec.name          = "nerd_dice"
  spec.version       = NerdDice::VERSION
  spec.authors       = ["Michael Duchemin"]
  spec.email         = ["statelesscode@gmail.com"]

  spec.summary       = "A Ruby Gem for rolling polyhedral dice."
  spec.description   = <<-GEM_DESCRIPTION
    Nerd dice allows you to roll polyhedral dice and add bonuses as you would in
    a tabletop roleplaying game. You can choose to roll multiple dice and keep a
    specified number of dice such as rolling 4d6 and dropping the lowest for
    ability scores or rolling with advantage and disadvantage if those mechanics
    exist in your game.
  GEM_DESCRIPTION
  spec.homepage = "https://github.com/statelesscode/nerd_dice"
  spec.licenses = %w[Unlicense MIT]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/statelesscode/nerd_dice"
  spec.metadata["changelog_uri"] = "https://github.com/statelesscode/nerd_dice/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/statelesscode/nerd_dice/issues"
  spec.metadata["documentation_uri"] = "https://github.com/statelesscode/nerd_dice/README.md"
  spec.metadata["github_repo"] = "https://github.com/statelesscode/nerd_dice"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Certs and signing
  spec.cert_chain  = ["certs/msducheminjr.pem"]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  # Dependencies
  spec.add_dependency "securerandom", "~> 0.2", ">= 0.2.2"

  # Development Dependencies
  spec.add_development_dependency "coveralls_reborn", "~> 0.27.0"
  spec.add_development_dependency "rubocop", "~> 1.46", ">= 1.46.0"
  spec.add_development_dependency "rubocop-performance", "~> 1.16", ">= 1.16.0"
  spec.add_development_dependency "rubocop-rake", "~> 0.6", ">= 0.6.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.18", ">= 2.18.1"
  spec.add_development_dependency "simplecov-lcov", "~> 0.8.0"
end
