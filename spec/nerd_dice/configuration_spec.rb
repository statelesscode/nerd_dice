# frozen_string_literal: true

RSpec.describe NerdDice::Configuration do
  subject(:config) { described_class.new }

  it "has default ability_score_array_size of 6" do
    expect(config.ability_score_array_size).to eq(6)
  end

  it "has default randomization_technique of :random_object" do
    expect(config.randomization_technique).to eq(:random_object)
  end

  it "has default refresh_seed_interval of 50" do
    expect(config.refresh_seed_interval).to be_nil
  end

  it "allows you to set refresh_seed_interval of 50" do
    config.refresh_seed_interval = 5000
    expect(config.refresh_seed_interval).to eq(5000)
  end

  it "will not let you choose a randomization_technique unless it's on the list" do
    expect { config.randomization_technique = :evil_hacker_random }.to raise_error(
      NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
    )
  end

  it "will let you set randomization_technique to a valid value" do
    config.randomization_technique = :securerandom
    expect(config.randomization_technique).to eq(:securerandom)
  end
end
