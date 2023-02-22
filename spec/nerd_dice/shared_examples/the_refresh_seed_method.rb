# frozen_string_literal: true

require "support/refresh_seed_helper"

RSpec.configure do |config|
  config.include RefreshSeedHelper
end

RSpec.shared_examples "a properly refreshed seed" do
  before { execute_with_config(*config_vars) }

  it "has the seed reset to zero" do
    expect(described_class.count_since_last_refresh).to eq(0)
  end
end

RSpec.shared_examples "a nil return technique" do
  before { execute_with_config(*config_vars) }

  it "has a return value of nil" do
    expect(actual_return).to be_nil
  end
end

RSpec.shared_examples "a non-nil return technique" do
  before { execute_with_config(*config_vars) }

  it "does not have a return value of nil" do
    expect(actual_return).not_to be_nil
  end
end

RSpec.shared_examples "an expected return value" do
  before { execute_with_config(*config_vars) }

  it "matches expected return Hash" do
    expect(actual_return).to eq(expected_return)
  end
end

RSpec.shared_examples "a specified random_rand seed" do
  before { execute_with_config(*config_vars) }

  it "matches supplied new random_rand value" do
    expect(RefreshSeedHelper::NEW_RANDOM_RAND_SEED).to eq(Random.seed)
  end
end

RSpec.shared_examples "a specified random_object seed" do
  before { execute_with_config(*config_vars) }

  it "matches supplied new random_object value" do
    expect(described_class.instance_variable_get(:@random_object).seed).to eq(RefreshSeedHelper::NEW_RANDOM_OBJECT_SEED)
  end
end

RSpec.shared_examples "a specified randomization technique" do
  let(:arg_technique) { config_vars[1][:randomization_technique] }
  before { execute_with_config(*config_vars) }

  it "does not match the configuration randomization technique" do
    expect(described_class.configuration.randomization_technique).not_to eq(:arg_technique)
  end

  it "does not have a nil argument technique" do
    expect(arg_technique).not_to be nil
  end
end
