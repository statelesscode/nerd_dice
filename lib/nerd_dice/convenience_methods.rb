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
  #     roll_2d20 foreground_color: 'blue' # => DiceSet: NerdDice.roll_dice(20, 2, foreground_color: 'blue')
  #     roll_2d20 foreground_color: 'blue' # => DiceSet: NerdDice.roll_dice(20, 2, foreground_color: 'blue')
  #     total_d12 randomization_technique: :randomized
  #     # => Integer NerdDice.total_dice(12, randomization_technique: :randomized)
  #     total_22d1000 randomization_technique: :random_rand
  #     # => Integer NerdDice.total_dice(1000, 22, randomization_technique: :random_rand)
  #     roll_4d6_with_advantage3 foreground_color: 'blue'
  #     # => DiceSet: NerdDice.roll_dice(4, 3, foreground_color: 'blue').highest(3)
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
    DIS = /_(with_disadvantage|lowest)/.freeze
    ADV = /_(with_advantage|highest)/.freeze
    MOD = /(_p(lus)?\d+|_m(inus)?\d+)/.freeze
    OVERALL_REGEXP = /\A(roll|total)_\d*d\d+((#{ADV}|#{DIS})\d*)?#{MOD}?\z/.freeze

    def method_missing(method_name, *args, **kwargs, &block)
      if match_pattern_and_delegate(method_name, *args, **kwargs, &block)
        # send the method after defining it
        send(method_name, *args, **kwargs, &block)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_all)
      symbol.to_s.match?(OVERALL_REGEXP) || super
    end

    private

      def match_pattern_and_delegate(method_name, *args, **kwargs, &block)
        case method_name.to_s
        when /\Aroll_\d*d\d+((#{ADV}|#{DIS})\d*)?#{MOD}?\z/o then define_roll_nndnn(method_name, *args, **kwargs,
                                                                                    &block)
        when /\Atotal_\d*d\d+((#{ADV}|#{DIS})\d*)?#{MOD}?\z/o then define_total_nndnn(method_name, *args, **kwargs,
                                                                                      &block)
        else
          false
        end
      end

      def define_roll_nndnn(method_name, *_args, **_kwargs)
        sides, number_of_dice, number_to_keep = parse_from_method_name(method_name)
        (class << self; self; end).class_eval do
          define_method method_name do |*_args, **kwargs|
            modifier = get_modifier_from_method_name!(method_name, kwargs)
            kwargs[:bonus] = modifier if modifier
            dice = NerdDice.roll_dice(sides, number_of_dice, **kwargs)
            parse_number_to_keep(dice, method_name, number_to_keep)
          end
        end
      end

      def define_total_nndnn(method_name, *_args, **_kwargs)
        (class << self; self; end).class_eval do
          define_method method_name do |*_args, **kwargs|
            modifier = get_modifier_from_method_name!(method_name, kwargs)
            kwargs[:bonus] = modifier if modifier
            determine_total_method(method_name, kwargs)
          end
        end
      end

      def determine_total_method(method_name, kwargs)
        sides, number_of_dice, number_to_keep = parse_from_method_name(method_name)
        if number_to_keep
          dice = NerdDice.roll_dice(sides, number_of_dice, **kwargs)
          parse_number_to_keep(dice, method_name, number_to_keep).total
        else
          NerdDice.total_dice(sides, number_of_dice, **kwargs)
        end
      end

      def parse_from_method_name(method_name)
        sides = get_sides_from_method_name(method_name)
        number_of_dice = get_number_of_dice_from_method_name(method_name)
        number_to_keep = get_number_to_keep_from_method_name(method_name, number_of_dice)
        [sides, number_of_dice, number_to_keep]
      end

      def get_sides_from_method_name(method_name)
        match_data = method_name.to_s.match(/d\d+/)

        return nil unless match_data

        # return the Integer portion after the d
        match_data.to_s[1..].to_i
      end

      def get_number_of_dice_from_method_name(method_name, _default = 1)
        match_data = method_name.to_s.match(/_\d+d/)
        default = method_name.to_s.match?(/_d\d+((#{ADV}|#{DIS})\d*)/o) ? 2 : 1
        match_data ? match_data.to_s[1...-1].to_i : default
      end

      def get_modifier_from_match_data(match_data)
        if match_data.to_s.match?(/_p(lus)?\d+/)
          match_data.to_s.match(/_p(lus)?\d+/).to_s.match(/\d+/).to_s.to_i
        else
          match_data.to_s.match(/_m(inus)?\d+/).to_s.match(/\d+/).to_s.to_i * -1
        end
      end

      def get_modifier_from_method_name!(method_name, kwargs)
        match_data = method_name.to_s.match(MOD)

        return nil unless match_data

        modifier = get_modifier_from_match_data(match_data)

        check_bonus_integrity!(kwargs, modifier)
        modifier
      end

      def get_number_to_keep_from_method_name(method_name, number_of_dice)
        return nil unless method_name.to_s.match?(/(#{ADV}|#{DIS})/o)

        specified_number = method_name.to_s.match(/(#{ADV}|#{DIS})\d+/o)

        # set the default to 1 if only one die or number minus 1 if multiple
        default = number_of_dice == 1 ? 1 : number_of_dice - 1

        # return pattern match if one exists or number of dice -1 if no pattern match
        specified_number ? specified_number.to_s.match(/\d+/).to_s.to_i : default
      end

      def check_bonus_integrity!(kwargs, bonus)
        raise NerdDice::Error, "bonus integrity failure" if kwargs && kwargs[:bonus] && kwargs[:bonus].to_i != bonus

        true
      end

      def parse_number_to_keep(dice, method_name, number_to_keep)
        return dice unless number_to_keep

        match_data = method_name.to_s.match(ADV)
        match_data ? dice.highest(number_to_keep) : dice.lowest(number_to_keep)
      end
  end
end
