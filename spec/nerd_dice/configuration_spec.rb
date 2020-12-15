# frozen_string_literal: true

RSpec.describe NerdDice::Configuration do
  it "has default ability_score_array_size of 6" do
    config = described_class.new
    expect(config.ability_score_array_size).to eq(6)
  end

  it "has default randomization_technique of :random_new_once" do
    config = described_class.new
    expect(config.randomization_technique).to eq(:random_new_once)
  end

  it "has default new_random_interval of 50" do
    config = described_class.new
    expect(config.new_random_interval).to eq(50)
  end

  it "will not let you choose a randomization_technique unless it's on the list" do
    config = described_class.new
    expect { config.randomization_technique = :evil_hacker_random }.to raise_error(
      NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
    )
  end

  it "will let you set randomization_technique to a valid value" do
    config = described_class.new
    config.randomization_technique = :random_new_interval
    expect(config.randomization_technique).to eq(:random_new_interval)
  end
end
