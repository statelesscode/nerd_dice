# frozen_string_literal: true

###############################
# execute_die_roll class method
###############################
# Usage:
#   If you wanted to execute a single d4 die roll without a Die object, you would execute:
#   <tt>NerdDice.execute_die_roll(4)</tt>
#
#   If you wanted to execute a die roll with a different randomization technique
#   than the one in NerdDice.configuration, you can supply an optional second argument
#   <tt>NerdDice.execute_die_roll(4, :randomized)</tt>
module NerdDice
  class << self
    # Arguments:
    #   number_of_sides (Integer) =>  the number of sides of the die to roll
    #   using_generator (Symbol) => must be one of the symbols in
    #     RANDOMIZATION_TECHNIQUES or nil
    #
    # Return (Integer) => Value of the single die rolled
    def execute_die_roll(number_of_sides, using_generator = nil)
      @count_since_last_refresh ||= 0
      gen = get_number_generator(using_generator)
      result = gen.rand(number_of_sides) + 1
      increment_and_evalutate_refresh_seed
      result
    end

    private

      def get_number_generator(using_generator = nil)
        using_generator ||= configuration.randomization_technique
        case using_generator
        when :securerandom then SecureRandom
        when :random_rand then Random
        when :random_object then @random_object ||= Random.new
        when :randomized then random_generator
        else raise ArgumentError, "Unrecognized generator. Must be one of #{RANDOMIZATION_TECHNIQUES.join(', ')}"
        end
      end

      def random_generator
        gen = RANDOMIZATION_TECHNIQUES.reject { |el| el == :randomized }.sample
        get_number_generator(gen)
      end
  end
end
