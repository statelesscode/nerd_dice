# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".roll_dnn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  describe "roll_dNN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, **method_options).and_call_original
      magic.roll_d20(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8).and_call_original
      magic.roll_d8
    end

    it "defines the method after it is called" do
      magic.roll_d100(**method_options)
      expect(magic.public_methods).to include(:roll_d100)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_d12, **method_options).once.and_call_original
      magic.roll_d12(**method_options)
      magic.roll_d12
      magic.roll_d12(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d6)).to eq(true)
    end
  end
end