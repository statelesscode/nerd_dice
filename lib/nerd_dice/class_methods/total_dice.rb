# frozen_string_literal: true

############################
# total_dice class method
############################
# Usage:
#   If you wanted to roll a single d4, you would execute:
#   <tt>NerdDice.total_dice(4)</tt>
#
#   If you wanted to roll 3d6, you would execute
#   <tt>NerdDice.total_dice(6, 3)</tt>
#
#   If you wanted to roll a d20 and add 5 to the value, you would execute
#   <tt>NerdDice.total_dice(20, 1, bonus: 5)</tt>
#
#   The bonus in the options hash must be an Integer duck type or nil
module NerdDice
  class << self
    # Arguments:
    #   number_of_sides (Integer) =>  the number of sides of the dice to roll
    #   number_of_dice (Integer, DEFAULT: 1) => the quantity to roll of the type
    #     of die specified in the number_of_sides argument.
    #   opts (options Hash, DEFAULT: {}) any additional options you wish to include
    #     :bonus (Integer) => The total bonus (positive integer) or penalty
    #       (negative integer) to modify the total by. Is added to the total of
    #       all dice after they are totaled, not to each die rolled
    #     :randomization_technique (Symbol) => must be one of the symbols in
    #       RANDOMIZATION_TECHNIQUES or nil
    #
    # Return (Integer) => Total of the dice rolled, plus modifier if applicable
    def total_dice(number_of_sides, number_of_dice = 1, **opts)
      total = 0
      number_of_dice.times do
        total += execute_die_roll(number_of_sides, opts[:randomization_technique])
      end
      begin
        total += opts[:bonus].to_i
      rescue NoMethodError
        raise ArgumentError, "Bonus must be a value that responds to :to_i"
      end
      total
    end
  end
end
