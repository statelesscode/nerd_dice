# frozen_string_literal: true

module NerdDice
  # The NerdDice::Die class allows you to instantiate and roll a die by specifying
  # the number of sides with other options. As part of initialization the die will
  # be rolled and have a value
  #
  # Usage:
  #   Instantiate a d20:
  #   <tt>die = NerdDice::Die.new(20)
  #       die.value # between 1 and 20
  #   </tt>
  #
  #   You can also specify options when instantiating
  #   <tt>NerdDice::Die.new(12, randomization_technique: :randomized,
  #                        foreground_color: "#FF0000",
  #                        background_color: "#FFFFFF",
  #                        damage_type: "necrotic"))
  #   </tt>
  class Die
    include Comparable

    attr_reader :number_of_sides, :randomization_technique, :value
    attr_accessor :background_color, :foreground_color, :damage_type, :is_included_in_total

    def <=>(other)
      value <=> other.value
    end

    def randomization_technique=(new_value)
      unless RANDOMIZATION_TECHNIQUES.include?(new_value) || new_value.nil?
        raise NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      end

      @randomization_technique = new_value
    end

    # rolls the die, setting the value to the new roll and returning that value
    def roll
      @value = NerdDice.execute_die_roll(@number_of_sides, @randomization_technique)
    end

    alias included_in_total? is_included_in_total

    private

      def initialize(number_of_sides, **opts)
        @number_of_sides = number_of_sides
        self.randomization_technique = opts[:randomization_technique]
        @background_color = opts[:background_color] || NerdDice.configuration.die_background_color
        @foreground_color = opts[:foreground_color] || NerdDice.configuration.die_foreground_color
        @damage_type = opts[:damage_type]
        @is_included_in_total = true
        roll
      end
  end
end
