# NerdDice
Nerd dice allows you to roll polyhedral dice and add bonuses as you would in a tabletop roleplaying game. You can choose to roll multiple dice and keep a specified number of dice such as rolling 4d6 and dropping the lowest for ability scores or rolling with advantage and disadvantage if those mechanics exist in your game.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nerd_dice'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nerd_dice

## Usage
### Rolling a number of dice and adding a bonus
```ruby
# roll a single d4
NerdDice.total_dice(4) # => return random Integer between 1-4

# roll 3d6
NerdDice.total_dice(6, 3) => return Integer total of three 6-sided dice

# roll a d20 and add 5 to the value
NerdDice.total_dice(20, 1, { bonus: 5 })
```
__NOTE:__ If provided, the bonus must be an ```Integer``` or it will be ignored

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/statelesscode/nerd_dice/issues. We welcome and encourage your participation in this open-source project. We welcome those of all backgrounds and abilities, but we refuse to adopt the Contributor Covenant for reasons outlined in [BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE.md](https://github.com/statelesscode/nerd_dice/blob/master/BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE.md)


## Unlicense, License, and Copyright

The document is dual-licensed under the [MIT](https://opensource.org/licenses/MIT) license and the [UNLICENSE](https://unlicense.org/) \(with strong preference toward the UNLICENSE\)\. The content is released under [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/) \(no rights reserved\). You are free to include it in its original form or modified with or without modification in your own project\.