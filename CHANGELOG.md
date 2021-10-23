# Nerd Dice Changelog

## master \(unreleased\)
### Added
### Changed
### Fixed

## 0.4.0 \(2021-10-23\)
### Added
* Add `NerdDice::ConvenienceMethods` method_missing mixin module that allows for dynamic invocation of patterns in the method name that get converted into calls to `NerdDice.roll_dice` or `NerdDice.total_dice` along with allowing the advantage/disadvantage mechanic or bonuses to be parsed from the method name. Full documentation of the module can be found in the [Convenience Methods Mixin](README.md#convenience-methods-mixin) section of the README.
* Add exensive specs to support the ConvenienceMethods module
### Changed
* Replace `Benchmark.bmbm` with `Benchmark.bm` in the nerd_dice_benchmark
* Add convenience_methods to nerd_dice_benchmark
* Extend `NerdDice::ConvenienceMethods` into top-level module as class methods
### Fixed
* Fix typos and horizontal scrolling in README
* Fix CodeClimate Code Smell on harvest_totals

## 0.3.0 \(2021-09-11\)
### Added
* Add new options to `NerdDice::Configuration`
  - `ability_score_number_of_sides`
  - `ability_score_dice_rolled`
  - `ability_score_dice_kept`
* Add `NerdDice.harvest_totals` method that takes in a collection and returns the results of calling `total` on each element
* Add `NerdDice.roll_ability_scores` convenience method that returns an array of `DiceSet` objects based on options and/or configuration
* Add `NerdDice.total_ability_scores` convenience method that returns an array of integers based on options and/or configuration
* Add `NerdDice::Die` class that represents a single die object and mixes in the `Comparable` module
* Add `NerdDice::DiceSet` class that represents a collection of `Die` objects and mixes in the `Enumerable` module
* Add `NerdDice::SetsRandomizationTechnique` mixin module and include in the `DiceSet` and `Die` classes
* Add `die_background_color` and `die_foreground_color` to `Configuration` class with defaults defined as constants
* Add `NerdDice.roll_dice` method that behaves in a similar fashion to `total_dice` but returns a `DiceSet` object instead of an `Integer` and has additional optional arguments relating to the non-numeric attributes of the dice
* Add `coveralls_reborn` to RSpec and GitHub actions
* Add build badge to README
* Add Code Climate maintainability integration and badge to README
* Add `nerd_dice_benchmark` script to bin directory
* Add GitHub Action CI build
  - Run RSpec test suite, fail if specs fail, report coverage via Coveralls
  - Run RuboCop and fail if violations
  - Run benchmark suite and fail if outside of allowed ratios
### Changed
* Update RuboCop version and configuration
* Break up the NerdDice source code file into several smaller files that are included by the module
* Enforce that `NerdDice.configuration.ability_score_array_size` must be a positive duck-type integer
### Fixed

## 0.2.0 \(2021-01-28\)
### Added
* Add ability to configure with `NerdDice.configure` block or `NerdDice.configuration`
  - Configure `randomization_technique` as `:random_rand`, `:securerandom`, `:random_object`, or `randomized`
  - Configure `refresh_seed_interval` to allow a periodic refresh of the seed
* Add `randomization_technique` option to `NerdDice.total_dice` method keyword arguments
* Add a lower-level `execute_die_roll` method that allows you to roll a single die with a generator specified
* Add ability to manually refresh or specify seed with `:refresh_seed!` method
### Changed
* Change `opts = {}` final argument to use keyword args `**opts` in the `NerdDice.total_dice` method. Now the method can be called as follows:
```ruby
# old
NerdDice.total_dice(20, 1, {bonus: 5})
NerdDice.total_dice(6, 3, {bonus: 1})

# new
NerdDice.total_dice(20, bonus: 5)
NerdDice.total_dice(6, 3, bonus: 1)
```
* Call `:to_i` on bonus instead of using `:is_a?` and raise ArgumentError in the `NerdDice.total_dice` method if it doesn't respond to `:to_i`
* Added `securerandom` as an explicit dependency due to Ruby 3.x change to bundled gem
* `total_dice` no longer calls unqualified `.rand` which improves performance on all generators except for `:securerandom`
### Fixed

## 0.1.1 \(2020-12-12\)
### Added
### Changed
### Fixed
* Fix broken link to CHANGELOG in gemspec
* Fix rubocop offenses from 0.1.0 and refactor specs

## 0.1.0 \(2020-12-07\)

### Added
* Add NerdDice.total_dice class method with the ability to roll multiple polyhedral dice and add a bonus
