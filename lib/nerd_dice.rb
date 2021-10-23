# frozen_string_literal: true

require "nerd_dice/version"
require "nerd_dice/configuration"
require "nerd_dice/sets_randomization_technique"
require "nerd_dice/die"
require "nerd_dice/dice_set"
require "nerd_dice/class_methods"
require "securerandom"
require "nerd_dice/convenience_methods"
# Nerd dice allows you to roll polyhedral dice and add bonuses as you would in
# a tabletop roleplaying game. You can choose to roll multiple dice and keep a
# specified number of dice such as rolling 4d6 and dropping the lowest for
# ability scores or rolling with advantage and disadvantage if those mechanics
# exist in your game.
#
# This module is broken down into multiple source files:
#   The class_methods file has all of the module_level methods called by NerdDice.method_name
#
# See the README for overall usage for the module
module NerdDice
  class Error < StandardError; end

  RANDOMIZATION_TECHNIQUES = %i[securerandom random_rand random_object randomized].freeze
  ABILITY_SCORE_KEYS = %i[ability_score_array_size ability_score_number_of_sides ability_score_dice_rolled
                          ability_score_dice_kept].freeze

  extend ConvenienceMethods
end
