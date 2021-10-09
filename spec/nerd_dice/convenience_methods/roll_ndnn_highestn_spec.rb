# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".roll_ndnn_highestn" do
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

  describe "roll_NdNN_highestN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      magic.roll_3d20_highest2(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      magic.roll_4d8_highest1
    end

    it "excludes lowest die from total" do
      result = magic.roll_4d8_highest3
      expect(result.min.included_in_total?).to eq(false)
    end

    it "includes highest N dice in total" do
      result = magic.roll_4d8_highest3
      result.sort[1..].each { |die| expect(die.included_in_total?).to eq(true) }
    end

    it "rolls 4 dice" do
      result = magic.roll_4d8_highest3
      expect(result.length).to eq(4)
    end

    it "defines the method after it is called" do
      magic.roll_35d100_highest20(**method_options)
      expect(magic.public_methods).to include(:roll_35d100_highest20)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_5d12_highest3, **method_options).once.and_call_original
      magic.roll_5d12_highest3(**method_options)
      magic.roll_5d12_highest3
      magic.roll_5d12_highest3(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_4d6_highest3)).to eq(true)
    end
  end

  describe "roll_NdNN_highest method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      # equivalent to roll_3d20_highest2
      magic.roll_3d20_highest(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      # equivalent to roll_4d8_highest3
      magic.roll_4d8_highest
    end

    it "excludes lowest die from total" do
      # equivalent to roll_4d8_highest3
      result = magic.roll_4d8_highest
      expect(result.min.included_in_total?).to eq(false)
    end

    it "includes highest N dice in total" do
      # equivalent to roll_4d8_highest3
      result = magic.roll_4d8_highest
      result.sort[1..].each { |die| expect(die.included_in_total?).to eq(true) }
    end

    it "rolls 4 dice" do
      # equivalent to roll_4d8_highest3
      result = magic.roll_4d8_highest
      expect(result.length).to eq(4)
    end

    it "includes the only die if 1 specified" do
      # equivalent to roll_1d20_highest1
      result = magic.roll_1d20_highest
      expect(result[0].included_in_total?).to eq(true)
    end

    it "defines the method after it is called" do
      # equivalent to 35d100_highest34
      magic.roll_35d100_highest(**method_options)
      expect(magic.public_methods).to include(:roll_35d100_highest)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_5d12_highest, **method_options).once.and_call_original
      # equivalent to roll_5d12_highest4
      magic.roll_5d12_highest(**method_options)
      magic.roll_5d12_highest
      magic.roll_5d12_highest(**method_options)
    end

    it "responds to methods matching the pattern" do
      # equivalent to roll_4d6_highest3
      expect(magic.respond_to?(:roll_4d6_highest)).to eq(true)
    end
  end

  describe "roll_NdNN_highest with bonuses and penalties" do
    it "calls calls NerdDice.roll_dice with correct arguments, keywords with bonus" do
      merged_options = method_options.merge(bonus: 6)
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_highest2_plus6(**method_options)
    end

    it "calls calls NerdDice.roll_dice with correct arguments, keywords with penalty" do
      merged_options = method_options.merge(bonus: -5)
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_highest_m5(**method_options)
    end

    it "raises error if bonus or penalty does not match the keyword argument" do
      expect { magic.roll_3d20_highest_minus4 bonus: 5 }.to raise_error(
        NerdDice::Error, "bonus integrity failure"
      )
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_3d20_highest_minus4)).to eq(true)
    end
  end
end
