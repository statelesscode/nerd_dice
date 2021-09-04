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
  # Background and foreground die colors are string values. By default these correspond to the constants in the class
    # Defaults: DEFAULT_BACKGROUND_COLOR = "#0000DD" DEFAULT_FOREGROUND_COLOR = "#DDDDDD"
    # It is recommended but not enforced that these should be valid CSS color property attributes
  config.die_background_color = "red"
  config.die_foreground_color = "#000"
end
```

### Rolling a number of dice and adding a bonus
You can use two different methods to roll dice. The `total_dice` method returns an `Integer` representing the total of the dice plus any applicable bonuses. The `total_dice` method does not support chaining additional methods like `highest`, `lowest`, `with_advantage`, `with_disadvantage`. The `roll_dice` method returns a `DiceSet` collection object, and allows for chaining  the methods mentioned above and iterating over the individual `Die` objects. `NerdDice.roll_dice.total` and `NerdDice.total_dice` are roughly equivalent.

```ruby
# roll a single d4
NerdDice.total_dice(4) # => return random Integer between 1-4
NerdDice.roll_dice(4) # => return a DiceSet with one 4-sided Die with a value between 1-4
NerdDice.roll_dice(4).total # => return random Integer between 1-4

# roll 3d6
NerdDice.total_dice(6, 3) # => return Integer total of three 6-sided dice
NerdDice.roll_dice(6, 3) # => return a DiceSet  with three 6-sided Die objects, each with values between 1-6
NerdDice.roll_dice(6, 3).total # => return Integer total of three 6-sided dice

# roll a d20 and add 5 to the value
NerdDice.total_dice(20, bonus: 5) # rolls a d20 and adds the bonus to the total => Integer
NerdDice.roll_dice(20, bonus: 5) # return a DiceSet with one 20-sided Die with a value between 1-20 and a bonus attribute of 5
NerdDice.roll_dice(20, bonus: 5).total # rolls a d20 and adds the bonus to the total => Integer

# without changing the config at the module level
# roll a d20 and overide the configured randomization_technique one time
NerdDice.total_dice(20, randomization_technique: :randomized) # => Integer
# roll a d20 and overide the configured randomization_technique for the DiceSet object will persist on the DiceSet object for subsequent rerolls
NerdDice.roll_dice(20, randomization_technique: :randomized) # => DiceSet with randomization_technique: :randomized
```
__NOTE:__ If provided, the bonus must respond to `:to_i` or an `ArgumentError` will be raised

### Taking actions on the dice as objects using the DiceSet object
The `NerdDice.roll_dice` method or the `NerdDice::DiceSet.new` methods return a collection object with an array of one or more `Die` objects. There are properties on both the `DiceSet` object and the `Die` object. Applicable properties are cascaded from the `DiceSet` to the `Die` objects in the collection by default.

```ruby
# These are equivalent
dice_set = NerdDice.roll_dice(6, 3, bonus: 2, randomization_technique: :randomized, damage_type: 'psychic', foreground_color: '#FFF', background_color: '#0FF')
# => NerdDice::DiceSet
dice_set = NerdDice::DiceSet.new(6, 3, bonus: 2, randomization_technique: :randomized, damage_type: 'psychic', foreground_color: '#FFF', background_color: '#0FF')
# => NerdDice::DiceSet
```
#### Available options for NerdDice::DiceSet objects
There are a number of options that can be provided when initializing a `NerdDice::DiceSet` object after specifying the mandatory number of sides and the optional number of dice \(default: 1\). The list below provides the options and indicates whether they are cascaded to the Die objects in the collection.
* `bonus` \(Duck-type Integer, _default: 0_\): Bonus or penalty to apply to the total after all dice are rolled.  _**Not applied** to Die objects_
* `randomization_technique` \(Symbol, _default: nil_\): Randomization technique override to use for the `DiceSet`. If `nil` it will use the value in `NerdDice.configuration`. _**Applied** to Die objects by default with ability modify_
* `damage_type` (\String, _default: nil_\): Optional string indicating the damage type associated with the dice for systems where it is relevant. _**Applied** to Die objects by default with ability modify_
* `foreground_color` (\String, _default: `NerdDice.configuration.die_foreground_color`_\): Intended foreground color to apply to the dice in the `DiceSet`. Should be a valid CSS color but is not validated or enforced and doesn\'t currently have any real functionality associated with it.   _**Applied** to Die objects by default with ability modify_
* `background_color` (\String, _default: `NerdDice.configuration.die_background_color`_\): Intended background color to apply to the dice in the `DiceSet`. Should be a valid CSS color but is not validated or enforced and doesn\'t currently have any real functionality associated with it.   _**Applied** to Die objects by default with ability modify_

#### Properties of individual Die objects
When initialized from a `DiceSet` object most of the properties of the `Die` object are inherited from the `DiceSet` object. In addition, there is an `is_included_in_total` public attribute that can be set to indicate whether the value of that particular die should be included in the total for its parent `DiceSet`. This property always starts out as true when the `Die` is initialized, but can be set to false.

```ruby
# six sided die
die = NerdDice::Die.new(6, randomization_technique: :randomized, damage_type: 'psychic', foreground_color: '#FFF', background_color: '#0FF')
die.is_included_in_total # => true
die.included_in_total? # => true
die.is_included_in_total  = false
die.included_in_total? # => false

# value property
die.value # =>  Integer between 1 and number_of_sides
die.roll # => Integer. Rolls/rerolls the Die and sets value to the result of the roll. Returns the new value
```
#### Iterating through dices in a DiceSet
The `DiceSet` class mixes in the `Enumerable` module and the `Die` object mixes in the `Comparable` module. This allows you to iterate over the dice in the collection. The `sort` method on the dice will return the die objects in ascending value from lowest to highest.

```ruby
dice_set = NerdDice.roll_dice(6, 3) # => NerdDice::DiceSet
dice_set.dice => Array of Die objects
dice_set.length # => 3. (dice_set.dice.length)
dice_set[0] # => NerdDice::Die (first element of dice array)
# take actions on each die
dice_set.each do |die|
  # print the current value
  puts "Die value before reroll is #{die.value}"
  # set the foreground_color of the die
  die.foreground_color = ["gray", "#FF0000#", "#d9d9d9", "green"].shuffle.first
  # reroll the die
  die.roll
  # print the new value
  puts "Die value after reroll is #{die.value}"
  # do other things
end
```
#### Methods and method chaining on the DiceSet
Since the DiceSet is an object, you can call methods that operate on the result returned and allow for things like the 5e advantage/disadvantage mechanic, the ability to re-roll all of the dice in the `DiceSet`, or to mark them all as included in the total.

```ruby
##############################################
# highest/with_advantage and lowest/with_disadvantage methods
#       assuming 4d6 with values of [1, 3, 4, 6]
##############################################
dice_set = NerdDice.roll_dice(6, 4)
# the 6, 4, and 3 will have is_included_in_total true while the 1 has it false
dice_set.highest(3) # => Returns the existing DiceSet object with the changes made to dice inclusion
dice_set.with_advantage(3) # => Alias of highest method
# calling total after highest/with_advantage for this DiceSet
dice_set.total # => 13
# same DiceSet using lowest. The 1, 3, and 4 will have is_included_in_total true while the 6 has it false
dice_set.lowest(3) # => Returns the existing DiceSet object with the changes made to dice inclusion
dice_set.with_disadvantage(3) # => Alias of lowest method
# calling total after lowest/with_disadvantage for this DiceSet
dice_set.total # => 8
# you can chain these methods (assumes the same seed as the above examples)
NerdDice.roll_dice(6, 4).with_advantage(3).total # => 13
NerdDice.roll_dice(6, 4).lowest(3).total # => 8

# reroll_all! method
dice_set = NerdDice.roll_dice(6, 4)
dice_set.reroll_all! # rerolls each of the Die objects in the collection and re-includes them in the total

# include_all_dice! method
dice_set.include_all_dice! # resets is_included_in_total to true for all Die objects
```

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
