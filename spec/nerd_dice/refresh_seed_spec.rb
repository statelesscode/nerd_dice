# frozen_string_literal: true

# require "nerd_dice/shared_examples/the_refresh_seed!_method"

RSpec.describe NerdDice, ".refresh_seed!" do
  context "with no arguments" do
    it "does nothing and returns nil for securerandom technique" do
      described_class.configuration.randomization_technique = :securerandom
      return_value = described_class.refresh_seed!
      expect(return_value).to be_nil
    end

    it "refreshes the kernel seed and returns the old seed for random_rand technique" do
      described_class.configuration.randomization_technique = :random_rand
      first_seed = 24_601
      Random.srand first_seed
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_rand_prior_seed: first_seed})
    end
    it "replaces the random object and returns the old seed for random_object technique" do
      described_class.configuration.randomization_technique = :random_object
      first_seed = 24_601
      described_class.instance_variable_set(:@random_object, Random.new(first_seed))
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_object_prior_seed: first_seed})
    end
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique" do
      described_class.configuration.randomization_technique = :randomized
      random_rand_initial_seed = 24_601
      random_object_initial_seed = 1_337
      Random.srand random_rand_initial_seed
      described_class.instance_variable_set(:@random_object, Random.new(random_object_initial_seed))
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_rand_prior_seed: random_rand_initial_seed, random_object_prior_seed: random_object_initial_seed })
    end
  end

  context "with seed argument(s) supplied" do
    it "does nothing and returns nil for securerandom technique" do
      described_class.configuration.randomization_technique = :securerandom
      return_value = described_class.refresh_seed!(securerandom_seed: 400)
      expect(return_value).to be_nil
    end
    it "refreshes the kernel seed and returns the old seed for random_rand technique"
    it "replaces the random object and returns the old seed for random_object technique"
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique"
  end

  context "with randomization techniques supplied" do
    it "does nothing and returns nil for securerandom technique" do
      return_value = described_class.refresh_seed!(technique: :securerandom)
      expect(return_value).to be_nil
    end
    it "refreshes the kernel seed and returns the old seed for random_rand technique"
    it "replaces the random object and returns the old seed for random_object technique"
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique"
  end
end
