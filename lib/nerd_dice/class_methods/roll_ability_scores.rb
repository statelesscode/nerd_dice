# frozen_string_literal: true

############################
# roll_ability_scores method
############################
# Usage:
#   If you wanted to get an array of DiceSet objects with your ability scores and
#   default configuration you would execute:
#   <tt>ability_score_array = NerdDice.roll_ability_scores</tt>
#
#   If you wanted to specify configuration for the current operation without
#   modifying the NerdDice.configuration, you can supply options for both the
#   ability_score configuration and the properties of the DiceSet objects returned.
#   Properties are specified in the method comment
#   <tt>
#     ability_score_array = NerdDice.roll_ability_scores(
#       ability_score_array_size: 7,
#       ability_score_number_of_sides: 8,
#       ability_score_dice_rolled: 5,
#       ability_score_dice_kept: 4,
#       foreground_color: "#FF0000",
#       background_color: "#FFFFFF"
#     )
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
    #     :foreground_color (String) => should resolve to a valid CSS color (format flexible)
    #     :background_color (String) => should resolve to a valid CSS color (format flexible)
    #
    # Return (Array of NerdDice::DiceSet) => One NerdDice::DiceSet element for each ability score
    # rubocop:disable Metrics/MethodLength
    def roll_ability_scores(**opts)
      dice_opts = opts.reject { |key, _value| key.to_s.match?(/\Aability_score_[a-z_]+\z/) }
      ability_score_options = interpret_ability_score_options(opts)
      ability_score_array = []
      ability_score_options[:ability_score_array_size].times do
        ability_score_array << roll_dice(
          ability_score_options[:ability_score_number_of_sides],
          ability_score_options[:ability_score_dice_rolled],
          **dice_opts
        ).highest(
          ability_score_options[:ability_score_dice_kept]
        )
      end
      ability_score_array
    end
    # rubocop:enable Metrics/MethodLength

    private

      def interpret_ability_score_options(opts)
        return_hash = {}
        ABILITY_SCORE_KEYS.each { |key| return_hash[key] = parse_ability_score_option(opts, key) }
        return_hash
      end

      def parse_ability_score_option(option_hash, option_key)
        option_hash[option_key] || configuration.send(option_key.to_s)
      end
  end
end
