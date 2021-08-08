[![Coverage Status](https://coveralls.io/repos/github/statelesscode/nerd_dice/badge.svg?branch=master)](https://coveralls.io/github/statelesscode/nerd_dice?branch=master)
![Build](https://github.com/statelesscode/nerd_dice/actions/workflows/main.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/721f587b792d583065be/maintainability)](https://codeclimate.com/github/statelesscode/nerd_dice/maintainability)
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
### Configuration
You can customize the behavior of NerdDice via a configuration block as below or by assigning an individual property via the ```NerdDice.configuration.property = value``` syntax \(where ```property``` is the config property and ```value``` is the value you want to assign\)\. The available configuration options as well as their defaults, if applicable, are listed in the example configuration block below:

```ruby
NerdDice.configure do | config|

  # number of ability scores to place in an ability score array
  config.ability_score_array_size = 6

  # randomization technique options are:
    # :securerandom => Uses SecureRandom.rand(). Good entropy, medium speed.
    # :random_rand => Uses Random.rand(). Class method. Poor entropy, fastest speed.
      # (Seed is shared with other processes. Too predictable)
    # :random_object => Uses Random.new() and calls rand()
      # Medium entropy, fastest speed. (Performs the best under speed benchmark)
    # :randomized => Uses a random choice of the :securerandom, :rand, and :random_new_interval options above
  config.randomization_technique = :random_object # fast with independent seed

  # Number of iterations to use on a generator before refreshing the seed
    # 1 very slow and heavy pressure on processor and memory but very high entropy
    # 1000 would refresh the object every 1000 times you call rand()
  config.refresh_seed_interval = nil # don't refresh the seed
end
```

### Rolling a number of dice and adding a bonus
```ruby
# roll a single d4
NerdDice.total_dice(4) # => return random Integer between 1-4

# roll 3d6
NerdDice.total_dice(6, 3) # => return Integer total of three 6-sided dice

# roll a d20 and add 5 to the value
NerdDice.total_dice(20, bonus: 5)

# roll a d20 and overide the configured randomization_technique one time
# without changing the config
NerdDice.total_dice(20, randomization_technique: :randomized)
```
__NOTE:__ If provided, the bonus must respond to `:to_i` or an `ArgumentError` will be raised

### Manually setting or refreshing the random generator seed
For randomization techniques other than `:securerandom` you can manually set or refresh the generator's seed by calling the `refresh_seed!` method. This is automatically called at the interval specified in `NerdDice.configuration.refresh_seed_interval` if it is not nil.

```ruby
# no arguments, will refresh the seed for the configured generator(s) only
NerdDice.refresh_seed! # => hash with old seed(s) or nil if :securerandom

# OPTIONS:
    #   randomization_technique (Symbol) => NerdDice::RANDOMIZATION_TECHNIQUES
    #   random_rand_seed (Integer) => Seed to set for Random
    #   random_object_seed (Integer) => Seed to set for new Random object
NerdDice.refresh_seed!(randomization_technique:  :randomized,
                       random_rand_seed:         1337,
                       random_object_seed:       24601)
```
__NOTE:__ Ability to specify a seed it primarily provided for testing purposes. This makes all random numbers generated _transparently deterministic_ and should not be used if you want behavior approximating randomness.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/statelesscode/nerd_dice/issues. We welcome and encourage your participation in this open-source project. We welcome those of all backgrounds and abilities, but we refuse to adopt the Contributor Covenant for reasons outlined in [BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE.md](https://github.com/statelesscode/nerd_dice/blob/master/BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE.md)


## Unlicense, License, and Copyright

The document is dual-licensed under the [MIT](https://opensource.org/licenses/MIT) license and the [UNLICENSE](https://unlicense.org/) \(with strong preference toward the UNLICENSE\)\. The content is released under [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/) \(no rights reserved\). You are free to include it in its original form or modified with or without modification in your own project\.
