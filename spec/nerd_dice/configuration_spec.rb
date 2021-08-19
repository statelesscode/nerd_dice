# frozen_string_literal: true

RSpec.describe NerdDice::Configuration do
  subject(:config) { described_class.new }

  it "has default ability_score_array_size of 6" do
    expect(config.ability_score_array_size).to eq(6)
  end

  it "has default randomization_technique of :random_object" do
    expect(config.randomization_technique).to eq(:random_object)
  end

  it "has default refresh_seed_interval of nil" do
    expect(config.refresh_seed_interval).to be_nil
  end

  it "has default die_background_color of #0000DD" do
    expect(config.die_background_color).to eq("#0000DD")
  end

  it "has default die_background_color of #DDDDDD" do
    expect(config.die_foreground_color).to eq("#DDDDDD")
  end

  it "allows you to set refresh_seed_interval to 5000" do
    config.refresh_seed_interval = 5000
    expect(config.refresh_seed_interval).to eq(5000)
  end

  it "does not allow a zero refresh_seed_interval" do
    expect { config.refresh_seed_interval = 0 }.to raise_error(
      NerdDice::Error, "refresh_seed_interval must be a positive integer or nil"
    )
  end

  it "does not allow negative refresh_seed_interval" do
    expect { config.refresh_seed_interval = -6 }.to raise_error(
      NerdDice::Error, "refresh_seed_interval must be a positive integer or nil"
    )
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

  it "will let you set the die_background_color" do
    config.die_background_color = "#DD0000"
    expect(config.die_background_color).to eq("#DD0000")
  end

  it "will let you set the die_foreground_color" do
    config.die_foreground_color = "#00DD00"
    expect(config.die_foreground_color).to eq("#00DD00")
  end
end
