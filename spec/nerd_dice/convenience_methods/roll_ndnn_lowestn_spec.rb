# frozen_string_literal: true

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

  describe "roll_dNN_lowest method" do
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
      expect(result.max.included_in_total?).to eq(false)
    end

    it "includes lowest N dice in total" do
      result = magic.roll_4d8_lowest3
      result.sort[0...-1].each { |die| expect(die.included_in_total?).to eq(true) }
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
      expect(magic.respond_to?(:roll_4d6_lowest3)).to eq(true)
    end
  end
end
