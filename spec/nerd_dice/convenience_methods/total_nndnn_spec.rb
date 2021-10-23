# frozen_string_literal: true

# total_NdNN pattern spec
# Covers situation pattern of /total_\d+d\d+/
# * Rolls specified number of dice
# * Returns an Integer
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * total_2d20 randomization_technique: :random_rand => roll 2 d20 using Random.rand technique
#   * total_1d8 => roll 1 d8 (same as total_d8)
RSpec.describe NerdDice::ConvenienceMethods, ".total_nndnn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  describe "total_dNN method" do
    it "calls NerdDice.total_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:total_dice).with(20, 3, **method_options).and_call_original
      magic.total_3d20(**method_options)
    end

    it "calls NerdDice.total_dice with no keywords" do
      expect(NerdDice).to receive(:total_dice).with(8, 22).and_call_original
      magic.total_22d8
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:total_dice).with(4, 1, **method_options).and_call_original
      magic.total_1d4(**method_options)
    end

    it "defines the method after it is called" do
      magic.total_6d100(**method_options)
      expect(magic.public_methods).to include(:total_6d100)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_2d12, **method_options).once.and_call_original
      magic.total_2d12(**method_options)
      magic.total_2d12
      magic.total_2d12(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_3d6)).to eq(true)
    end
  end
end
