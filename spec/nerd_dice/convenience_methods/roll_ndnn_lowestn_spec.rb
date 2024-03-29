# frozen_string_literal: true

# roll_dNN_lowest(N) pattern spec
# Covers situation pattern of /roll_\d+d\d+_lowest\d*/
# * Rolls specified dice and keeps the lowest specified number of dice
# * If number of dice not specified keeps number of dice -1 (minimum of 1)
# * Returns a NerdDice::DiceSet object
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * roll_3d20_lowest2 => roll 3 d20 and take the lowest 2
#   * roll_3d8_lowest_plus6 => roll 3 d8 and take the lowest 2 then add 6
RSpec.describe NerdDice::ConvenienceMethods, ".roll_ndnn_lowestn" do
  before do
    NerdDice.instance_variable_set(:@configuration, NerdDice::Configuration.new)
    NerdDice.configuration.randomization_technique = :random_rand
    NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
  end

  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  # specify number to keep
  describe "roll_NdNN_lowestN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      magic.roll_3d20_lowest2(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      magic.roll_4d8_lowest1
    end

    it "excludes highest die from total" do
      result = magic.roll_4d8_lowest3
      expect(result.max.included_in_total?).to be(false)
    end

    it "includes lowest N dice in total" do
      result = magic.roll_4d8_lowest3
      result.sort[0...-1].each { |die| expect(die.included_in_total?).to be(true) }
    end

    it "rolls 4 dice" do
      result = magic.roll_4d8_lowest3
      expect(result.length).to eq(4)
    end

    it "defines the method after it is called" do
      magic.roll_35d100_lowest20(**method_options)
      expect(magic.public_methods).to include(:roll_35d100_lowest20)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_5d12_lowest3, **method_options).once.and_call_original
      magic.roll_5d12_lowest3(**method_options)
      magic.roll_5d12_lowest3
      magic.roll_5d12_lowest3(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_4d6_lowest3)).to be(true)
    end
  end

  # without specifying number to keep
  describe "roll_NdNN_lowest method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      # equivalent to roll_3d20_lowest2
      magic.roll_3d20_lowest(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      # equivalent to roll_4d8_lowest3
      magic.roll_4d8_lowest
    end

    it "excludes highest die from total" do
      # equivalent to roll_4d8_lowest3
      result = magic.roll_4d8_lowest
      expect(result.max.included_in_total?).to be(false)
    end

    it "includes lowest N dice in total" do
      # equivalent to roll_4d8_lowest3
      result = magic.roll_4d8_lowest
      result.sort[0...-1].each { |die| expect(die.included_in_total?).to be(true) }
    end

    it "rolls 4 dice" do
      # equivalent to roll_4d8_lowest3
      result = magic.roll_4d8_lowest
      expect(result.length).to eq(4)
    end

    it "includes the only die if 1 specified" do
      # equivalent to roll_1d20_lowest1
      result = magic.roll_1d20_lowest
      expect(result[0].included_in_total?).to be(true)
    end

    it "defines the method after it is called" do
      # equivalent to roll_35d100_lowest34
      magic.roll_35d100_lowest(**method_options)
      expect(magic.public_methods).to include(:roll_35d100_lowest)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_5d12_lowest, **method_options).once.and_call_original
      # equivalent to roll_5d12_lowest4
      magic.roll_5d12_lowest(**method_options)
      magic.roll_5d12_lowest
      magic.roll_5d12_lowest(**method_options)
    end

    it "responds to methods matching the pattern" do
      # equivalent to roll_4d6_lowest3
      expect(magic.respond_to?(:roll_4d6_lowest)).to be(true)
    end
  end

  # combine with bonuses and penalties
  describe "roll_NdNN_lowest with bonuses and penalties" do
    it "calls calls NerdDice.roll_dice with correct arguments, keywords with bonus" do
      merged_options = method_options.merge(bonus: 6)
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_lowest2_plus6(**method_options)
    end

    it "calls calls NerdDice.roll_dice with correct arguments, keywords with penalty" do
      merged_options = method_options.merge(bonus: -5)
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_lowest_m5(**method_options)
    end

    it "raises error if bonus or penalty does not match the keyword argument" do
      expect { magic.roll_3d20_lowest_minus4 bonus: 5 }.to raise_error(
        NerdDice::Error, /#{get_bonus_error_message(5, -4)}/
      )
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_3d20_lowest_minus4)).to be(true)
    end
  end
end
