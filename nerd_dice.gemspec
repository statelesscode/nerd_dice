require_relative 'lib/nerd_dice/version'

Gem::Specification.new do |spec|
  spec.name          = "nerd_dice"
  spec.version       = NerdDice::VERSION
  spec.authors       = ["Michael Duchemin"]
  spec.email         = ["statelesscode@gmail.com"]

  spec.summary       = %q{A Ruby Gem for rolling polyhedral dice.}
  spec.description   = <<-EOF
    Nerd dice allows you to roll polyhedral dice and add bonuses as you would in 
    a tabletop roleplaying game. You can choose to roll multiple dice and keep a 
    specified number of dice such as rolling 4d6 and dropping the lowest for 
    ability scores or rolling with advantage and disadvantage if those mechanics 
    exist in your game.
  EOF
  spec.homepage      = "https://github.com/statelesscode/nerd_dice"
  spec.licenses       = ["Unlicense", "MIT"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/statelesscode/nerd_dice"
  spec.metadata["changelog_uri"] = "https://github.com/statelesscode/nerd_dice/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/statelesscode/nerd_dice/issues"
  spec.metadata["documentation_uri"] = "https://github.com/statelesscode/nerd_dice/README.md"
  spec.metadata["documentation_uri"] = "https://github.com/statelesscode/nerd_dice/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
