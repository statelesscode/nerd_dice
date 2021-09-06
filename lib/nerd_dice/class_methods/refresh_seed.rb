# frozen_string_literal: true

############################
# refresh_seed! class method
############################
# Usage:
#   NerdDice.refresh_seed! by default will refresh the seed for the generator
#   configured in NerdDice.configuration. It can also be used with arguments
#   to set a particular seed for use with deterministic testing. It sets
#   the count_since_last_refresh to 0 whenever called.
#
#   It cannot refresh or manipulate the seed for SecureRandom
#
#   <tt>NerdDice.refresh_seed!</tt>
#
#   With options
#   <tt>
#     previous_seed_data = NerdDice.refresh_seed!(
#       randomization_technique: :randomized,
#       random_rand_seed: 1337,
#       random_object_seed: 24601
#     )
#   </tt>
module NerdDice
  class << self
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

      def refresh_random_rand_seed!(new_seed)
        new_seed ? Random.srand(new_seed) : Random.srand
      end

      def refresh_random_object_seed!(new_seed)
        old_seed = @random_object&.seed
        @random_object = new_seed ? Random.new(new_seed) : Random.new
        old_seed
      end

      def increment_and_evalutate_refresh_seed
        @count_since_last_refresh += 1
        return unless configuration.refresh_seed_interval

        refresh_seed! if @count_since_last_refresh >= configuration.refresh_seed_interval
      end
  end
end
