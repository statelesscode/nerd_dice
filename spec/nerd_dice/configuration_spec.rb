# frozen_string_literal: true

require "nerd_dice/shared_examples/a_duck_type_integer_attribute"

RSpec.describe NerdDice::Configuration do
  subject(:config) { described_class.new }

  it "has default ability_score_array_size of 6" do
    expect(config.ability_score_array_size).to eq(6)
  end

  it "has default ability_score_number_of_sides of 6" do
    expect(config.ability_score_number_of_sides).to eq(6)
  end

  it "has default ability_score_dice_rolled of 4" do
    expect(config.ability_score_dice_rolled).to eq(4)
  end

  it "has default ability_score_dice_kept of 3" do
    expect(config.ability_score_dice_kept).to eq(3)
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

  it "does not let you choose a randomization_technique unless it's on the list" do
    expect { config.randomization_technique = :evil_hacker_random }.to raise_error(
      NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
    )
  end

  it "lets you set randomization_technique to a valid value" do
    config.randomization_technique = :securerandom
    expect(config.randomization_technique).to eq(:securerandom)
  end

  it "lets you set the die_background_color" do
    config.die_background_color = "#DD0000"
    expect(config.die_background_color).to eq("#DD0000")
  end

  it "lets you set the die_foreground_color" do
    config.die_foreground_color = "#00DD00"
    expect(config.die_foreground_color).to eq("#00DD00")
  end

  describe "duck-type Integer attributes" do
    describe "ability_score_array_size attribute writer errors" do
      it_behaves_like "a positive duck type integer attribute writer" do
        let(:attribute_name) { "ability_score_array_size" }
      end
    end
  end

  describe "ability_score_number_of_sides attribute writer errors" do
    it_behaves_like "a positive duck type integer attribute writer" do
      let(:attribute_name) { "ability_score_number_of_sides" }
    end
  end

  describe "ability_score_dice_rolled attribute writer errors" do
    it_behaves_like "a positive duck type integer attribute writer" do
      let(:attribute_name) { "ability_score_dice_rolled" }
    end

    it "allows you to set the value lower than dice kept" do
      config.ability_score_dice_rolled = 2
      expect(config.ability_score_dice_rolled).to eq(2)
    end

    it "reduces dice kept if set lower than dice kept" do
      config.ability_score_dice_rolled = 2
      expect(config.ability_score_dice_kept).to eq(2)
    end
  end

  describe "ability_score_dice_kept attribute writer errors" do
    it_behaves_like "a positive duck type integer attribute writer" do
      let(:attribute_name) { "ability_score_dice_kept" }
    end

    it "throws an error if you try to set it greater than ability_score_dice_rolled" do
      expect { config.ability_score_dice_kept = 12 }.to raise_error(
        NerdDice::Error, "cannot set ability_score_dice_kept greater than ability_score_dice_rolled"
      )
    end
  end
end
