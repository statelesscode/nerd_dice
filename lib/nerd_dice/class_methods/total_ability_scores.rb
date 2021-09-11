# frozen_string_literal: true

############################
# total_ability_scores method
############################
# Usage:
#   If you wanted to get an array of only the values of ability scores and
#   default configuration you would execute:
#   <tt>ability_score_array = NerdDice.total_ability_scores</tt>
#     => [15, 14, 13, 12, 10, 8]
#
#   If you wanted to specify configuration for the current operation without
#   modifying the NerdDice.configuration, you can supply options for both the
#   ability_score configuration and the properties of the DiceSet objects returned.
#
#   Many of the properties available in roll_ability_scores will not be relevant
#   to total_ability_scores but the method delegates all options passed without
#   filtering.
#   <tt>
#     ability_score_array = NerdDice.total_ability_scores(
#       ability_score_array_size: 7,
#       ability_score_number_of_sides: 8,
#       ability_score_dice_rolled: 5,
#       ability_score_dice_kept: 4,
#       randomization_technique: :randomized
#     )
#     => [27, 22, 13, 23, 20, 24, 23]
#   </tt>
module NerdDice
  class << self
    # Arguments:
    #   opts (options Hash, DEFAULT: {}) any options you wish to include
    #     ABILITY SCORE OPTIONS
    #     :ability_score_array_size DEFAULT NerdDice.configuration.ability_score_array_size
    #     :ability_score_number_of_sides DEFAULT NerdDice.configuration.ability_score_number_of_sides
    #     :ability_score_dice_rolled DEFAULT NerdDice.configuration.ability_score_dice_rolled
    #     :ability_score_dice_kept DEFAULT NerdDice.configuration.ability_score_dice_kept
    #
    #     DICE SET OPTIONS
    #     :randomization_technique (Symbol) => must be one of the symbols in
    #       RANDOMIZATION_TECHNIQUES or nil
    #
    #     ARGUMENTS PASSED ON THAT DO NOT REALLY MATTER
    #     :foreground_color (String) => should resolve to a valid CSS color (format flexible)
    #     :background_color (String) => should resolve to a valid CSS color (format flexible)
    #
    # Return (Array of Integers) => One Integer element for each ability score
    def total_ability_scores(**opts)
      harvest_totals(roll_ability_scores(**opts))
    end
  end
end
