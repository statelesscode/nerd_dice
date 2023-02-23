# frozen_string_literal: true

# roll_(N)dNN_mN pattern spec (shorthand for minus)
# Covers situation pattern of /roll_\d*d\d+_m_\d+/
# * Rolls specified number of dice or 1 die if not specified
# * Returns a NerdDice::DiceSet object
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * roll_3d20_m5 roll 3 d20 subtract 5
#   * roll_d8_m5 => roll 1 d8 subtract 5
RSpec.describe NerdDice::ConvenienceMethods, ".roll_nndnn_mn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand
    }
  end

  let(:merged_options) do
    {
      randomization_technique: :random_rand,
      bonus: -6
    }
  end

  # specify number of dice to roll
  describe "roll_NdNN_mN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_m6(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 22, bonus: -6).and_call_original
      magic.roll_22d8_m6
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:roll_dice).with(4, 1, **merged_options).and_call_original
      magic.roll_1d4_m6(**method_options)
    end

    it "defines the method after it is called" do
      magic.roll_6d100_m6(**method_options)
      expect(magic.public_methods).to include(:roll_6d100_m6)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_2d12_m6, **method_options).once.and_call_original
      magic.roll_2d12_m6(**method_options)
      magic.roll_2d12_m6
      magic.roll_2d12_m6(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_3d6_m24)).to be(true)
    end

    it "raises error if bonus is inconsistent with kwargs" do
      expect { magic.roll_2d12_m6 bonus: 5 }.to raise_error(
        NerdDice::Error, /#{get_bonus_error_message(5, -6)}/
      )
    end
  end

  # implicitly roll 1 die
  describe "roll_dNN_mN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 1, **merged_options).and_call_original
      magic.roll_d20_m6(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 1, bonus: -6).and_call_original
      magic.roll_d8_m6
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:roll_dice).with(4, 1, **merged_options).and_call_original
      magic.roll_d4_m6(**method_options)
    end

    it "defines the method after it is called" do
      magic.roll_d100_m6(**method_options)
      expect(magic.public_methods).to include(:roll_d100_m6)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_d12_m6, **method_options).once.and_call_original
      magic.roll_d12_m6(**method_options)
      magic.roll_d12_m6
      magic.roll_d12_m6(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d6_m24)).to be(true)
    end

    it "raises error if bonus is inconsistent with kwargs" do
      expect { magic.roll_d12_m6 bonus: 5 }.to raise_error(
        NerdDice::Error, /#{get_bonus_error_message(5, -6)}/
      )
    end
  end
end
