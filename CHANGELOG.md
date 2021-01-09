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
