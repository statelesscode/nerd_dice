# frozen_string_literal: true

require "nerd_dice/class_methods/configuration"
require "nerd_dice/class_methods/refresh_seed"
require "nerd_dice/class_methods/execute_die_roll"
require "nerd_dice/class_methods/total_dice"
require "nerd_dice/class_methods/roll_dice"
require "nerd_dice/class_methods/roll_ability_scores"
require "nerd_dice/class_methods/harvest_totals"

############################
# NerdDice class methods
# This file contains module-level attribute readers and writers and includes the other
# files that provide the class method functionality.
#
# PUBLIC METHODS
# NerdDice.configuration => ./class_methods/configuration.rb
# NerdDice.refresh_seed => ./class_methods/refresh_seed.rb
# NerdDice.execute_die_roll => ./class_methods/execute_die_roll.rb
# NerdDice.total_dice => ./class_methods/total_dice.rb
# NerdDice.roll_dice => ./class_methods/roll_dice.rb
# NerdDice.roll_ability_scores => ./class_methods/roll_ability_scores.rb
############################
module NerdDice
  class << self
    attr_reader :count_since_last_refresh
  end
end
