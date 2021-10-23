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

    # Override of method_missing
    # * Attempts to match pattern to the regular expression matching the methods
    #   we want to intercept
    # * If the method matches the pattern, it is defined and executed with send
    # * Subsequent calls to the same method name will not hit method_missing
    # * If the method name does not match the regular expression pattern, the default
    #   implementation of method_missing is called by invoking super
    def method_missing(method_name, *args, **kwargs, &block)
      # returns false if no match
      if match_pattern_and_delegate(method_name, *args, **kwargs, &block)
        # send the method after defining it
        send(method_name, *args, **kwargs, &block)
      else
        super
      end
    end

    # Override :respond_to_missing? so that :respond_to? works as expected when the
    # module is included.
    def respond_to_missing?(symbol, include_all)
      symbol.to_s.match?(OVERALL_REGEXP) || super
    end

    private

      # Compares the method name to the regular expression patterns for the module
      # * If the pattern matches the convenience method is defined and a truthy value is returned
      # * If the pattern does not match then the method returns false and method_missing invokes `super`
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

      # * Evaluates the method name and then uses class_eval and define_method to define the method
      # * Subsequent calls to the method will bypass method_missing
      #
      # Defined method will return a NerdDice::DiceSet
      def define_roll_nndnn(method_name, *_args, **_kwargs)
        sides, number_of_dice, number_to_keep = parse_from_method_name(method_name)
        # defines the method on the class mixing in the module
        (class << self; self; end).class_eval do
          define_method method_name do |*_args, **kwargs|
            modifier = get_modifier_from_method_name!(method_name, kwargs)
            kwargs[:bonus] = modifier if modifier
            # NerdDice::DiceSet object
            dice = NerdDice.roll_dice(sides, number_of_dice, **kwargs)
            # invoke highest or lowest on the DiceSet if applicable
            parse_number_to_keep(dice, method_name, number_to_keep)
          end
        end
      end

      # The implementation of this is different than the roll_ version because NerdDice.total_dice
      # cannot deal with highest/lowest calls
      # * Evaluates the method name and then uses class_eval and define_method to define the method
      # * Calls :determine_total_method to allow for handling of highest/lowest mechanic
      # * Subsequent calls to the method will bypass method_missing
      #
      # Defined method will return an Integer
      def define_total_nndnn(method_name, *_args, **_kwargs)
        (class << self; self; end).class_eval do
          define_method method_name do |*_args, **kwargs|
            # parse out bonus before calling determine_total_method
            modifier = get_modifier_from_method_name!(method_name, kwargs)
            kwargs[:bonus] = modifier if modifier
            # parse the method and take different actions based on method_name pattern
            determine_total_method(method_name, kwargs)
          end
        end
      end

      # Determines whether to call NerdDice.total_dice or NerdDice.roll_dice.total based on RegEx pattern
      # * If the method matches the ADV or DIS regular expressions, the method will call :roll_dice and :total
      # * If the method does not match ADV or DIS, the method will call :total_dice (which is faster)
      #
      # Returns Integer irrespective of which methodology is used
      def determine_total_method(method_name, kwargs)
        sides, number_of_dice, number_to_keep = parse_from_method_name(method_name)
        if number_to_keep
          # NerdDice::DiceSet
          dice = NerdDice.roll_dice(sides, number_of_dice, **kwargs)
          # invoke the highest or lowest method to define dice included and then return the total
          parse_number_to_keep(dice, method_name, number_to_keep).total
        else
          NerdDice.total_dice(sides, number_of_dice, **kwargs)
        end
      end

      # calls a series of parse methods and then returns them as an array so the define_ methods above can
      # use a one-liner to assign the variables
      def parse_from_method_name(method_name)
        sides = get_sides_from_method_name(method_name)
        number_of_dice = get_number_of_dice_from_method_name(method_name)
        number_to_keep = get_number_to_keep_from_method_name(method_name, number_of_dice)
        [sides, number_of_dice, number_to_keep]
      end

      # parses out the Integer value of number of sides from the method name
      # will only ever get called if the pattern matches so no need for guard against nil
      def get_sides_from_method_name(method_name)
        method_name.to_s.match(/d\d+/).to_s[1..].to_i
      end

      # parses the number of dice from the method name and returns the applicable Integer value
      # * If number of dice are specified in the method name, that value is used
      # * If number of dice are not specified and ADV or DIS match, the number is set to 2
      # * If number of dice are not specified and no ADV or DIS match, the number is set to 1
      def get_number_of_dice_from_method_name(method_name)
        match_data = method_name.to_s.match(/_\d+d/)
        default = method_name.to_s.match?(/_d\d+((#{ADV}|#{DIS})\d*)/o) ? 2 : 1
        match_data ? match_data.to_s[1...-1].to_i : default
      end

      # parses out the modifier from the method name
      # * Input must be a valid MatchData object matching the MOD regular expression
      # * Does not handle nil
      # * Only called from get_modifier_from_method_name!
      def get_modifier_from_match_data(match_data)
        if match_data.to_s.match?(/_p(lus)?\d+/)
          match_data.to_s.match(/_p(lus)?\d+/).to_s.match(/\d+/).to_s.to_i
        else
          match_data.to_s.match(/_m(inus)?\d+/).to_s.match(/\d+/).to_s.to_i * -1
        end
      end

      # Parses the method name to determine if the modifier pattern is present
      # * Returns nil if method name does not match pattern
      # * Calls get_modifier_from_match_data to get the Integer value of the modifier
      # * Calls check_bonus_integrity! to ensure that the parsed modifier matches the
      #   keyword argument if present (which will raise an error if they don't match)
      # * Returns the Integer value of the modifier
      def get_modifier_from_method_name!(method_name, kwargs)
        match_data = method_name.to_s.match(MOD)

        return nil unless match_data

        modifier = get_modifier_from_match_data(match_data)

        # will raise error if mismatch
        check_bonus_integrity!(kwargs, modifier)
        modifier
      end

      # Determines whether the highest/lowest/with_advantage/with_disadvantage pattern is present in the
      # method name and takes appropriate action
      # * Returns nil if no match
      # * Returns Integer value of number to keep otherwise (irrespective of highest/lowest)
      # * Takes the number to keep from the method name if specified
      # * Returns 1 if number to keep not specified and number of dice equals 1
      # * Returns number_of_dice -1 if number to keep not specified and more than one die
      def get_number_to_keep_from_method_name(method_name, number_of_dice)
        return nil unless method_name.to_s.match?(/(#{ADV}|#{DIS})/o)

        specified_number = method_name.to_s.match(/(#{ADV}|#{DIS})\d+/o)

        # set the default to 1 if only one die or number minus 1 if multiple
        default = number_of_dice == 1 ? 1 : number_of_dice - 1

        # return pattern match if one exists or number of dice -1 if no pattern match
        specified_number ? specified_number.to_s.match(/\d+/).to_s.to_i : default
      end

      # Checks that there is not a mismatch between the modifier specified in the method name and the
      # modifier specified in the keyword arguments if one is specified
      # * Raises a NerdDice::Error if there is a mismatch
      # * Returns true if no keyword argument bonus
      # * Returns true if keyword argument bonus and method name modifier are consistent
      def check_bonus_integrity!(kwargs, bonus)
        bonus_error_message = "Bonus integrity failure: "
        bonus_error_message += "Modifier specified in keyword arguments was #{kwargs[:bonus]}. "
        bonus_error_message += "Modifier specified in method_name was #{bonus}. "
        raise NerdDice::Error, bonus_error_message if kwargs && kwargs[:bonus] && kwargs[:bonus].to_i != bonus

        true
      end

      # Parses number to keep on a NerdDice::DiceSet
      # * If number_to_keep falsey, just return the DiceSet object
      # * If number_to_keep matches ADV pattern return DiceSet with highest called
      # * If number_to_keep matches DIS pattern return DiceSet with lowest called
      def parse_number_to_keep(dice, method_name, number_to_keep)
        return dice unless number_to_keep

        # use match against ADV to determine truth value of ternary expression
        match_data = method_name.to_s.match(ADV)
        match_data ? dice.highest(number_to_keep) : dice.lowest(number_to_keep)
      end
  end
end
