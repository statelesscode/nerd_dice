# frozen_string_literal: true

RSpec.describe NerdDice do
  it "has a version number" do
    expect(NerdDice::VERSION).not_to be nil
  end

  it "can be configured" do
    described_class.configure do |config|
      config.ability_score_array_size = 7 # default 6
    end

    expect(described_class.configuration.ability_score_array_size).to eq(7)
  end

  it "configure returns the configuration object" do
    result = described_class.configure do |config|
      config.ability_score_array_size = 7 # default 6
    end

    expect(result).to eq(described_class.configuration)
  end
end
