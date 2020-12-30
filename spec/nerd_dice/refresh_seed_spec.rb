# frozen_string_literal: true

# require "nerd_dice/shared_examples/the_refresh_seed!_method"

RSpec.describe NerdDice, ".refresh_seed!" do
  before { NerdDice.instance_variable_set(:@count_since_last_refresh, 100) }
  context "with no arguments" do
    it "does nothing and returns nil for securerandom technique" do
      described_class.configuration.randomization_technique = :securerandom
      return_value = described_class.refresh_seed!
      expect(return_value).to be_nil
      expect(described_class.count_since_last_refresh).to eq(0)
    end

    it "refreshes the kernel seed and returns the old seed for random_rand technique" do
      described_class.configuration.randomization_technique = :random_rand
      first_seed = 24_601
      Random.srand first_seed
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_rand_prior_seed: first_seed})
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "replaces the random object and returns the old seed for random_object technique" do
      described_class.configuration.randomization_technique = :random_object
      first_seed = 24_601
      described_class.instance_variable_set(:@random_object, Random.new(first_seed))
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_object_prior_seed: first_seed})
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique" do
      described_class.configuration.randomization_technique = :randomized
      random_rand_initial_seed = 24_601
      random_object_initial_seed = 1_337
      Random.srand random_rand_initial_seed
      described_class.instance_variable_set(:@random_object, Random.new(random_object_initial_seed))
      return_value = described_class.refresh_seed!
      expect(return_value).to eq({random_rand_prior_seed: random_rand_initial_seed, random_object_prior_seed: random_object_initial_seed })
      expect(described_class.count_since_last_refresh).to eq(0)
    end
  end

  context "with seed argument(s) supplied" do
    it "does nothing and returns nil for securerandom technique" do
      described_class.configuration.randomization_technique = :securerandom
      return_value = described_class.refresh_seed!(securerandom_seed: 400)
      expect(return_value).to be_nil
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "refreshes the kernel seed and returns the old seed for random_rand technique" do
      described_class.configuration.randomization_technique = :random_rand
      first_seed = 24_601
      new_seed = 10_642
      Random.srand first_seed
      return_value = described_class.refresh_seed!(random_rand_seed: new_seed)
      expect(return_value).to eq({random_rand_prior_seed: first_seed})
      expect(Random.seed).to eq(new_seed)
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "replaces the random object and returns the old seed for random_object technique" do
      described_class.configuration.randomization_technique = :random_object
      first_seed = 24_601
      new_seed = 10_642
      described_class.instance_variable_set(:@random_object, Random.new(first_seed))
      return_value = described_class.refresh_seed!(random_object_seed: new_seed)
      expect(return_value).to eq({random_object_prior_seed: first_seed})
      expect(described_class.instance_variable_get(:@random_object).seed).to eq(new_seed)
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique" do
      described_class.configuration.randomization_technique = :randomized
      random_rand_initial_seed = 24_601
      random_object_initial_seed = 1_337
      Random.srand random_rand_initial_seed
      random_rand_new_seed = 10_642
      random_object_new_seed = 7_331
      described_class.instance_variable_set(:@random_object, Random.new(random_object_initial_seed))
      return_value = described_class.refresh_seed!(random_object_seed: random_object_new_seed, random_rand_seed: random_rand_new_seed)
      expect(return_value).to eq({random_object_prior_seed: random_object_initial_seed, random_rand_prior_seed: random_rand_initial_seed})
      expect(Random.seed).to eq(random_rand_new_seed)
      expect(described_class.instance_variable_get(:@random_object).seed).to eq(random_object_new_seed)
      expect(described_class.count_since_last_refresh).to eq(0)
    end
  end

  context "with randomization techniques supplied" do
    it "does nothing and returns nil for securerandom technique" do
      return_value = described_class.refresh_seed!(technique: :securerandom)
      expect(return_value).to be_nil
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "refreshes the kernel seed and returns the old seed for random_rand technique" do
      first_seed = 24_601
      Random.srand first_seed
      return_value = described_class.refresh_seed!(technique: :random_rand)
      expect(return_value).to eq({random_rand_prior_seed: first_seed})
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "replaces the random object and returns the old seed for random_object technique" do
      first_seed = 24_601
      described_class.instance_variable_set(:@random_object, Random.new(first_seed))
      return_value = described_class.refresh_seed!(technique: :random_object)
      expect(return_value).to eq({random_object_prior_seed: first_seed})
      expect(described_class.count_since_last_refresh).to eq(0)
    end
    it "refreshes the kernel seed and random object and returns the old seeds for randomized technique" do
      random_rand_initial_seed = 24_601
      random_object_initial_seed = 1_337
      Random.srand random_rand_initial_seed
      described_class.instance_variable_set(:@random_object, Random.new(random_object_initial_seed))
      return_value = described_class.refresh_seed!(technique: :randomized)
      expect(return_value).to eq({random_rand_prior_seed: random_rand_initial_seed, random_object_prior_seed: random_object_initial_seed })
      expect(described_class.count_since_last_refresh).to eq(0)
    end
  end
end
