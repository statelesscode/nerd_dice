# Nerd Dice Changelog

## master \(unreleased\)
### Added
* Add ability to configure with `NerdDice.configure` block or `NerdDice.configuration`
  - Configure `randomization_technique` as `:random_rand`, `:securerandom`, `:random_object`, or `randomized`
  - Configure `refresh_seed_interval` to allow a periodic refresh of the seed
* Add a lower-level `execute_die_roll` method that allows you to roll a single die with a generator specified
* Add ability to manually refresh or specify seed with `:refresh_seed!` method
* Added branding .svgs and .pngs to assets/branding
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
