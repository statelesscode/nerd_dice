# frozen_string_literal: true

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

  describe "duck-type Integer attributes" do
    describe "ability_score_array_size attribute writer" do
      it "allows you to set a new array size" do
        config.ability_score_array_size = 7
        expect(config.ability_score_array_size).to eq(7)
      end

      it "allows you to provide a numeric string" do
        config.ability_score_array_size = "8"
        expect(config.ability_score_array_size).to eq(8)
      end
    end

    describe "ability_score_number_of_sides attribute writer" do
      it "allows you to set a new number of sides" do
        config.ability_score_number_of_sides = 8
        expect(config.ability_score_number_of_sides).to eq(8)
      end

      it "allows you to provide a numeric string" do
        config.ability_score_number_of_sides = "4"
        expect(config.ability_score_number_of_sides).to eq(4)
      end
    end

    describe "ability_score_dice_rolled attribute writer" do
      it "allows you to set a quantity of dice rolled" do
        config.ability_score_dice_rolled = 5
        expect(config.ability_score_dice_rolled).to eq(5)
      end

      it "allows you to provide a numeric string" do
        config.ability_score_dice_rolled = "3"
        expect(config.ability_score_dice_rolled).to eq(3)
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

    describe "ability_score_dice_kept attribute writer" do
      it "allows you to set a new quantity of dice_kept" do
        config.ability_score_dice_kept = 2
        expect(config.ability_score_dice_kept).to eq(2)
      end

      it "allows you to provide a numeric string" do
        config.ability_score_dice_kept = "4"
        expect(config.ability_score_dice_kept).to eq(4)
      end
    end
  end

  describe "validations and error handling" do
    describe "ability_score_array_size attribute writer errors" do
      let(:error_message) { "ability_score_array_size must be must be a positive value that responds to :to_i" }

      it "throws an ArgumentError if new value does not respond to to_i" do
        expect { config.ability_score_array_size = :threeve }.to raise_error(ArgumentError, error_message)
      end

      it "throws an ArgumentError if new value does not convert to positive integer" do
        expect { config.ability_score_array_size = "eleventy-billion" }.to raise_error(ArgumentError, error_message)
      end

      it "throws an ArgumentError if new value is 0" do
        expect { config.ability_score_array_size = 0 }.to raise_error(ArgumentError, error_message)
      end

      it "throws an ArgumentError if new value is a negative Integer" do
        expect { config.ability_score_array_size = -6 }.to raise_error(ArgumentError, error_message)
      end
    end
  end

  describe "ability_score_number_of_sides attribute writer errors" do
    let(:error_message) { "ability_score_number_of_sides must be must be a positive value that responds to :to_i" }

    it "throws an ArgumentError if new value does not respond to to_i" do
      expect { config.ability_score_number_of_sides = :threeve }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value does not convert to positive integer" do
      expect { config.ability_score_number_of_sides = "eleventy-billion" }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is 0" do
      expect { config.ability_score_number_of_sides = 0 }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is a negative Integer" do
      expect { config.ability_score_number_of_sides = -6 }.to raise_error(ArgumentError, error_message)
    end
  end

  describe "ability_score_dice_rolled attribute writer errors" do
    let(:error_message) { "ability_score_dice_rolled must be must be a positive value that responds to :to_i" }

    it "throws an ArgumentError if new value does not respond to to_i" do
      expect { config.ability_score_dice_rolled = :threeve }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value does not convert to positive integer" do
      expect { config.ability_score_dice_rolled = "eleventy-billion" }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is 0" do
      expect { config.ability_score_dice_rolled = 0 }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is a negative Integer" do
      expect { config.ability_score_dice_rolled = -6 }.to raise_error(ArgumentError, error_message)
    end
  end

  describe "ability_score_dice_kept attribute writer errors" do
    let(:error_message) { "ability_score_dice_kept must be must be a positive value that responds to :to_i" }

    it "throws an ArgumentError if new value does not respond to to_i" do
      expect { config.ability_score_dice_kept = :threeve }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value does not convert to positive integer" do
      expect { config.ability_score_dice_kept = "eleventy-billion" }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is 0" do
      expect { config.ability_score_dice_kept = 0 }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is a negative Integer" do
      expect { config.ability_score_dice_kept = -6 }.to raise_error(ArgumentError, error_message)
    end

    it "throws an error if you try to set it greater than ability_score_dice_rolled" do
      expect { config.ability_score_dice_kept = 12 }.to raise_error(
        NerdDice::Error, "cannot set ability_score_dice_kept greater than ability_score_dice_rolled"
      )
    end
  end
end
