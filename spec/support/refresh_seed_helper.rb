# frozen_string_literal: true

module RefreshSeedHelper
  ORIGINAL_RANDOM_RAND_SEED = 24_601
  NEW_RANDOM_RAND_SEED = 10_642
  ORIGINAL_RANDOM_OBJECT_SEED = 1_337
  NEW_RANDOM_OBJECT_SEED = 7_331
  COUNT_SINCE_LAST_REFRESH = 100

  def setup_example(randomization_technique)
    NerdDice.instance_variable_set(:@count_since_last_refresh, COUNT_SINCE_LAST_REFRESH)
    NerdDice.configuration.randomization_technique = randomization_technique if randomization_technique
  end

  def execute_with_config(randomization_technique, arg_options, expected_return)
    setup_example(randomization_technique)
    random_rand_prior_seed = nil
    random_object_prior_seed = nil
    @expected_return = expected_return
    if expected_return.is_a?(Hash)
      random_rand_prior_seed = expected_return[:random_rand_prior_seed]
      random_object_prior_seed = expected_return[:random_object_prior_seed]
    end
    Random.srand(random_rand_prior_seed) if random_rand_prior_seed
    NerdDice.instance_variable_set(:@random_object, Random.new(random_object_prior_seed)) if random_object_prior_seed
    @actual_return = if arg_options
      described_class.refresh_seed!(**arg_options)
    else
      described_class.refresh_seed!
    end
  end
end
