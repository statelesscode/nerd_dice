# frozen_string_literal: true

############################
# roll_dice class method
############################
# Usage:
#   If you wanted to roll a single d4, you would execute:
#   <tt>dice_set = NerdDice.roll_dice(4)</tt>
#
#   If you wanted to roll 3d6, you would execute
#   <tt>dice_set = NerdDice.roll_dice(6, 3)</tt>
#
#   If you wanted to roll a d20 and add 5 to the value, you would execute
#   <tt>dice_set = NerdDice.roll_dice(20, 1, bonus: 5)</tt>
#
#   Since this method returns a DiceSet, you can call any of the DiceSet
#   methods on the result. See the README for more details and options
module NerdDice
  class << self
    ############################
    # roll_dice class method
    ############################
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
    #     :foreground_color (String) => should resolve to a valid CSS color (format flexible)
    #     :background_color (String) => should resolve to a valid CSS color (format flexible)
    #     :damage_type: (String) => damage type for the dice set, if applicable
    #
    # Return (NerdDice::DiceSet) => Collection object with one or more Die objects
    #
    # You can call roll_dice().total to get similar functionality to total_dice
    # or you can chain methods together roll_dice(6, 4, bonus: 3).with_advantage(3).total
    def roll_dice(number_of_sides, number_of_dice = 1, **opts)
      DiceSet.new(number_of_sides, number_of_dice, **opts)
    end
  end
end
