# frozen_string_literal: true

RSpec.describe NerdDice::Die do
  subject(:die) { described_class.new(20) }

  context "with instantiation options" do
    it "sets the number of sides from the first argument" do
      expect(die.number_of_sides).to eq(20)
    end

    it "has expected default generator_override of nil" do
      expect(die.generator_override).to be_nil
    end

    it "has expected default foreground_color of #FFFFFF" do
      expect(die.foreground_color).to eq("#FFFFFF")
    end

    it "has expected default background_color of #0000FF" do
      expect(die.background_color).to eq("#0000FF")
    end

    it "has a value between 1 and number of sides" do
      expect(die.value).to be_between(1, 20)
    end
  end

  context "without instantiation options" do
    let(:die_with_options) do
      described_class.new(12,
                          generator_override: :randomized,
                          foreground_color: "#FF0000",
                          background_color: "#FFFFFF")
    end

    it "sets the number of sides from the first argument" do
      expect(die_with_options.number_of_sides).to eq(12)
    end

    it "has applies the generator_override from options" do
      expect(die_with_options.generator_override).to eq(:randomized)
    end

    it "has applies the provided foreground_color of #FF0000" do
      expect(die_with_options.foreground_color).to eq("#FF0000")
    end

    it "has expected default background_color of #FFFFFF" do
      expect(die_with_options.background_color).to eq("#FFFFFF")
    end

    it "has a value between 1 and number of sides" do
      expect(die_with_options.value).to be_between(1, 20)
    end
  end

  describe "roll method" do
    let(:original_value) { die.value }

    # rubocop:disable RSpec/ExampleLength
    it "replaces the value of the die" do
      changed = false
      5.times do
        die.roll
        changed = true if die.value != original_value
      end
      expect(changed).to eq(true)
    end
    # rubocop:enable RSpec/ExampleLength

    it "has the correct range" do
      5.times do
        die.roll
        expect(die.value).to be_between(1, 20)
      end
    end

    it "returns the new value" do
      roll_value = die.roll
      expect(roll_value).to eq(die.value)
    end
  end

  describe "error handling" do
    it "raises error if bad generator_override provided" do
      expect { described_class.new(6, generator_override: :invalid) }.to raise_error(
        NerdDice::Error, "generator_override must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      )
    end
  end
end
