# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".total_ndnn_lowestn" do
  before do
    NerdDice.instance_variable_set(:@configuration, NerdDice::Configuration.new)
    NerdDice.configuration.randomization_technique = :random_rand
    NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
  end

  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand
    }
  end

  describe "total_NdNN_lowestN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      magic.total_3d20_lowest2(**method_options)
    end

    it "equals NerdDice.roll_dice.total" do
      roll_version = NerdDice.roll_dice(20, 3, **method_options).lowest(2).total
      NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
      total_version = magic.total_3d20_lowest2(**method_options)
      expect(total_version).to eq(roll_version)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      magic.total_4d8_lowest1
    end

    it "returns an Integer" do
      expect(magic.total_4d8_lowest1).to be_an(Integer)
    end

    it "defines the method after it is called" do
      magic.total_35d100_lowest20(**method_options)
      expect(magic.public_methods).to include(:total_35d100_lowest20)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_5d12_lowest3, **method_options).once.and_call_original
      magic.total_5d12_lowest3(**method_options)
      magic.total_5d12_lowest3
      magic.total_5d12_lowest3(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_4d6_lowest3)).to eq(true)
    end
  end

  describe "total_NdNN_lowest method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
      # equivalent to total_3d20_lowest2
      magic.total_3d20_lowest(**method_options)
    end

    it "equals NerdDice.roll_dice.total" do
      roll_version = NerdDice.roll_dice(20, 3, **method_options).lowest(2).total
      NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
      # equivalent to total_3d20_lowest2
      total_version = magic.total_3d20_lowest(**method_options)
      expect(total_version).to eq(roll_version)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 4).and_call_original
      # equivalent to total_3d8_lowest3
      magic.total_4d8_lowest
    end

    it "returns an Integer" do
      # equivalent to total_3d8_lowest3
      expect(magic.total_4d8_lowest).to be_an(Integer)
    end

    it "includes the only die if 1 specified" do
      # equivalent to total_1d20_lowest1
      result = magic.total_1d20_lowest
      expect(result).to be > 0
    end

    it "defines the method after it is called" do
      # equivalent to total_35d100_lowest34
      magic.total_35d100_lowest(**method_options)
      expect(magic.public_methods).to include(:total_35d100_lowest)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_5d12_lowest, **method_options).once.and_call_original
      # equivalent to total_5d12_lowest4
      magic.total_5d12_lowest(**method_options)
      magic.total_5d12_lowest
      magic.total_5d12_lowest(**method_options)
    end

    it "responds to methods matching the pattern" do
      # equivalent to total_4d6_lowest3
      expect(magic.respond_to?(:total_4d6_lowest)).to eq(true)
    end
  end
end