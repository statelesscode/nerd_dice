# frozen_string_literal: true

# roll_NdNN pattern spec
# Covers situation pattern of /roll_\d+d\d+/
# * Rolls specified number of dice
# * Returns a NerdDice::DiceSet object
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * roll_2d20 randomization_technique: :random_rand => roll 2 d20 using Random.rand technique
#   * roll_1d8 => roll 1 d8 (same as roll_d8)
RSpec.describe NerdDice::ConvenienceMethods, ".roll_nndnn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  describe "roll_NNdNN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      magic.roll_3d20(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 22).and_call_original
      magic.roll_22d8
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:roll_dice).with(4, 1, **method_options).and_call_original
      magic.roll_1d4(**method_options)
    end

    it "defines the method after it is called" do
      magic.roll_6d100(**method_options)
      expect(magic.public_methods).to include(:roll_6d100)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_2d12, **method_options).once.and_call_original
      magic.roll_2d12(**method_options)
      magic.roll_2d12
      magic.roll_2d12(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_3d6)).to be(true)
    end
  end
end
