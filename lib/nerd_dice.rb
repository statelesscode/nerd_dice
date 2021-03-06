# frozen_string_literal: true

require "nerd_dice/version"
require "nerd_dice/configuration"
require "securerandom"
# Nerd dice allows you to roll polyhedral dice and add bonuses as you would in
# a tabletop roleplaying game. You can choose to roll multiple dice and keep a
# specified number of dice such as rolling 4d6 and dropping the lowest for
# ability scores or rolling with advantage and disadvantage if those mechanics
# exist in your game.
#
# Usage:
#   Right now there is only a single class method :total_dice
#
#   If you wanted to roll a single d4, you would execute:
#   <tt>NerdDice.total_dice(4)</tt>
#
#   If you wanted to roll 3d6, you would execute
#   <tt>NerdDice.total_dice(6, 3)</tt>
#
#   If you wanted to roll a d20 and add 5 to the value, you would execute
#   <tt>NerdDice.total_dice(20, 1, { bonus: 5 })</tt>
#
#   The bonus in the options hash must be an Integer or it will be ignored
module NerdDice
  class Error < StandardError; end

  RANDOMIZATION_TECHNIQUES = %i[securerandom random_rand random_object randomized].freeze

  class << self
    attr_reader :count_since_last_refresh

    ############################
    # configure class method
    ############################
    # Arguments: None
    # Expects and yields to a block where configuration is specified.
    # See README and NerdDice::Configuration class for config options
    # Return (NerdDice::Configuration) the Configuration object tied to the
    #   @configuration class instance variable
    def configure
      yield configuration
      configuration
    end

    ############################
    # configuration class method
    ############################
    # Arguments: None
    # Provides the lazy-loaded class instance variable @configuration
    # Return (NerdDice::Configuration) the Configuration object tied to the
    #   @configuration class instance variable
    def configuration
      @configuration ||= Configuration.new
    end

    ############################
    # total_dice class method
    ############################
    # Arguments:
    #   number_of_sides (Integer) =>  the number of sides of the dice to roll
    #   number_of_dice (Integer, DEFAULT: 1) => the quantity to roll of the type
    #     of die specified in the number_of_sides argument.
    #   options (Hash, DEFAULT: {}) any additional options you wish to include
    #     :bonus (Integer) => The total bonus (positive integer) or penalty
    #       (negative integer) to modify the total by. Is added to the total of
    #       all dice after they are totaled, not to each die rolled
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

    ############################
    # execute_die_roll class method
    ############################
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

    ############################
    # refresh_seed! class method
    ############################
    # Options: (none required)
    #   randomization_technique (Symbol) => must be one of the symbols in
    #     RANDOMIZATION_TECHNIQUES if specified
    #   random_rand_seed (Integer) => Seed to set for Random
    #   random_object_seed (Integer) => Seed to set for new Random object
    # Return (Hash or nil) => Previous values of generator seeds that were refreshed
    def refresh_seed!(**opts)
      technique, random_rand_new_seed, random_object_new_seed = parse_refresh_options(opts)
      @count_since_last_refresh = 0
      return nil if technique == :securerandom

      reset_appropriate_seeds!(technique, random_rand_new_seed, random_object_new_seed)
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

      def refresh_random_rand_seed!(new_seed)
        new_seed ? Random.srand(new_seed) : Random.srand
      end

      def refresh_random_object_seed!(new_seed)
        old_seed = @random_object&.seed
        @random_object = new_seed ? Random.new(new_seed) : Random.new
        old_seed
      end

      def parse_refresh_options(opts)
        [
          opts[:randomization_technique] || configuration.randomization_technique,
          opts[:random_rand_seed],
          opts[:random_object_seed]
        ]
      end

      # rubocop:disable Metrics/MethodLength
      def reset_appropriate_seeds!(technique, random_rand_new_seed, random_object_new_seed)
        return_hash = {}
        case technique
        when :random_rand
          return_hash[:random_rand_prior_seed] = refresh_random_rand_seed!(random_rand_new_seed)
        when :random_object
          return_hash[:random_object_prior_seed] = refresh_random_object_seed!(random_object_new_seed)
        when :randomized
          return_hash[:random_rand_prior_seed] = refresh_random_rand_seed!(random_rand_new_seed)
          return_hash[:random_object_prior_seed] = refresh_random_object_seed!(random_object_new_seed)
        end
        return_hash
      end
      # rubocop:enable Metrics/MethodLength

      def increment_and_evalutate_refresh_seed
        @count_since_last_refresh += 1
        return unless configuration.refresh_seed_interval

        refresh_seed! if @count_since_last_refresh >= configuration.refresh_seed_interval
      end
  end
end
