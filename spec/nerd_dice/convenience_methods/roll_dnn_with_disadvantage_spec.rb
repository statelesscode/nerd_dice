# frozen_string_literal: true

# roll_dNN_with_disadvantage pattern spec
# Covers situation pattern of /roll_d\d+_with_disadvantage/ with no number to keep specified
# * Rolls 2 dice and keeps the lowest
# * Returns a NerdDice::DiceSet object
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * roll_d20_with_disadvantage => roll 2 d20 and take the lowest
#   * roll_d8_with_disadvantage_plus6 => roll 2 d8 and take the lowest then add 6
RSpec.describe NerdDice::ConvenienceMethods, ".roll_dnn_with_disadvantage" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  describe "roll_dNN_with_disadvantage method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **method_options).and_call_original
      magic.roll_d20_with_disadvantage(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 2).and_call_original
      magic.roll_d8_with_disadvantage
    end

    it "includes lower die from total" do
      result = magic.roll_d8_with_disadvantage
      expect(result.min.included_in_total?).to be(true)
    end

    it "excludes higher die in total" do
      result = magic.roll_d8_with_disadvantage
      expect(result.sort[1].included_in_total?).to be(false)
    end

    it "rolls 2 dice" do
      result = magic.roll_d8_with_disadvantage
      expect(result.length).to eq(2)
    end

    it "defines the method after it is called" do
      magic.roll_d100_with_disadvantage(**method_options)
      expect(magic.public_methods).to include(:roll_d100_with_disadvantage)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_d12_with_disadvantage,
                                                     **method_options).once.and_call_original
      magic.roll_d12_with_disadvantage(**method_options)
      magic.roll_d12_with_disadvantage
      magic.roll_d12_with_disadvantage(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d6_with_disadvantage)).to be(true)
    end
  end

  # combine with bonuses and penalties
  describe "roll_dNN_with_disadvantage with bonuses and penalties" do
    it "calls calls NerdDice.roll_dice with correct arguments, keywords with bonus" do
      merged_options = method_options.merge(bonus: 6)
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **merged_options).and_call_original
      magic.roll_d20_with_disadvantage_plus6(**method_options)
    end

    it "calls calls NerdDice.roll_dice with correct arguments, keywords with penalty" do
      merged_options = method_options.merge(bonus: -5)
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **merged_options).and_call_original
      magic.roll_d20_with_disadvantage_m5(**method_options)
    end

    it "raises error if bonus or penalty does not match the keyword argument" do
      expect { magic.roll_d20_with_disadvantage_minus4 bonus: 5 }.to raise_error(
        NerdDice::Error, /#{get_bonus_error_message(5, -4)}/
      )
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d20_with_disadvantage_minus4)).to be(true)
    end
  end
end
