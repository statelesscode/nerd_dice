# frozen_string_literal: true

# total_dNN pattern spec
# Covers situation pattern of /total_d\d+/
# * Rolls 1 die
# * Returns an Integer
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * total_d20 randomization_technique: :random_rand => roll 1 d20 using Random.rand technique
#   * total_d8 => roll 1 d8
RSpec.describe NerdDice::ConvenienceMethods, ".total_dnn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      bonus: 3
    }
  end

  describe "total_dNN method" do
    it "calls NerdDice.total_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:total_dice).with(20, 1, **method_options).and_call_original
      magic.total_d20(**method_options)
    end

    it "calls NerdDice.total_dice with no keywords" do
      expect(NerdDice).to receive(:total_dice).with(8, 1).and_call_original
      magic.total_d8
    end

    it "defines the method after it is called" do
      magic.total_d100(**method_options)
      expect(magic.public_methods).to include(:total_d100)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_d12, **method_options).once.and_call_original
      magic.total_d12(**method_options)
      magic.total_d12
      magic.total_d12(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_d6)).to be(true)
    end
  end
end
