# frozen_string_literal: true

module NerdDice
  # The NerdDice::ConvenienceMethods module overrides the default behavior of method_missing to
  # provide the ability to dynamically roll dice with methods names that match specific patterns.
  #
  # Examples:
  #  `roll_dNN` and `total_dNN` roll one die
  #     <tt>
  #     roll_d20 # => DiceSet: NerdDice.roll_dice(20)
  #     roll_d8 # => DiceSet: NerdDice.roll_dice(8)
  #     roll_d1000 # => DiceSet: NerdDice.roll_dice(1000)
  #     total_d20 # => Integer NerdDice.total_dice(20)
  #     total_d8 # => Integer NerdDice.total_dice(8)
  #     total_d1000 # => Integer NerdDice.total_dice(1000)
  #     </tt>
  #
  # `roll_NNdNN` and `total_NNdNN` roll specified quantity of dice
  #     <tt>
  #     roll_2d20 # => DiceSet: NerdDice.roll_dice(20, 2)
  #     roll_3d8 # => DiceSet: NerdDice.roll_dice(8, 3)
  #     roll_22d1000 # => DiceSet: NerdDice.roll_dice(1000, 22)
  #     total_2d20 # => Integer NerdDice.total_dice(20, 2)
  #     total_3d8 # => Integer NerdDice.total_dice(8, 3)
  #     total_22d1000 # => Integer NerdDice.total_dice(1000, 22)
  #     </tt>
  #
  # Keyword arguments are passed on to `roll_dice`/`total_dice` method
  #     <tt>
  #     roll_2d20 color: 'blue' # => DiceSet: NerdDice.roll_dice(20, 2, color: 'blue')
  #     roll_2d20 color: 'blue' # => DiceSet: NerdDice.roll_dice(20, 2, color: 'blue')
  #     total_d12 randomization_technique: :randomized
  #     # => Integer NerdDice.total_dice(12, randomization_technique: :randomized)
  #     total_22d1000 randomization_technique: :random_rand
  #     # => Integer NerdDice.total_dice(1000, 22, randomization_technique: :random_rand)
  #     roll_4d6_with_advantage3 color: 'blue'
  #     # => DiceSet: NerdDice.roll_dice(4, 3, color: 'blue').highest(3)
  #     total_4d6_with_advantage3 randomization_technique: :random_rand
  #     # => Integer: NerdDice.roll_dice(4, 3, randomization_technique: :random_rand).highest(3).total
  #     </tt>
  #
  # Positive and negative bonuses can be used with `plus` (alias `p`) or `minus` (alias `m`) in DSL
  #     <tt>
  #     roll_d20_plus6 # => DiceSet: NerdDice.roll_dice(20, bonus: 6)
  #     total_3d8_p2 # => Integer: NerdDice.total_dice(8, 3, bonus: 2)
  #     total_d20_minus5 # => Integer: NerdDice.total_dice(20, bonus: -6)
  #     roll_3d8_m3 # => DiceSet: NerdDice.roll_dice(8, 3, bonus: -3)
  #     </tt>
  #
  # Advantage and disadvantage
  #  * `_with_advantageN` or `highestN` roll with advantage
  #  * `_with_disadvantageN` or `lowestN` roll with disadvantage
  #  * Calling `roll_dNN_with_advantage` \(and variants\) rolls 2 dice and keeps one
  #     <tt>
  #     # equivalent
  #     roll_3d8_with_advantage1
  #     roll_3d8_highest1
  #     # => DiceSet: NerdDice.roll_dice(8, 3).with_advantage(1)
  #     # calls roll_dice and total to return an integer
  #     total_3d8_with_advantage1
  #     total_3d8_highest1
  #     # => Integer: NerdDice.roll_dice(8, 3).with_advantage(1).total
  #     # rolls two dice in this case
  #     # equal to roll_2d20_with_advantage but more natural
  #     roll_d20_with_advantage # => DiceSet: NerdDice.roll_dice(20, 2).with_advantage(1)
  #     # equal to total_2d20_with_advantage but more natural
  #     total_d20_with_advantage # => Integer: NerdDice.roll_dice(20, 2).with_advantage(1).total
  #     </tt>
  #
  # Error Handling
  #  * If you try to call with a plus and a minus, an Exception is raised
  #  * If you call with a bonus and a keyword argument and they don't match, an Exception is raised
  #  * Any combination not expressly allowed or matched will call `super`
  #     <tt>
  #     roll_3d8_plus3_m2 # raise NerdDice::Error
  #     roll_3d8_plus3 bonus: 1 # raise NerdDice::Error
  #     roll_d20_with_advantage_lowest # will raise NameError using super method_missing
  #     total_4d6_lowest3_highest2 # will raise NameError using super method_missing
  module ConvenienceMethods
  end
end
