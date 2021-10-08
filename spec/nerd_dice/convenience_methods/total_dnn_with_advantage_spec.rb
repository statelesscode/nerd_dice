# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".total_dnn_with_advantage" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand
    }
  end

  describe "total_dNN_with_advantage method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **method_options).and_call_original
      magic.total_d20_with_advantage(**method_options)
    end

    it "equals NerdDice.roll_dice.total" do
      NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
      roll_version = NerdDice.roll_dice(20, 2, **method_options).with_advantage(1).total
      NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337)
      total_version = magic.total_d20_with_advantage(**method_options)
      expect(total_version).to eq(roll_version)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 2).and_call_original
      magic.total_d8_with_advantage
    end

    it "returns an Integer" do
      expect(magic.total_d8_with_advantage).to be_an(Integer)
    end

    it "defines the method after it is called" do
      magic.total_d100_with_advantage(**method_options)
      expect(magic.public_methods).to include(:total_d100_with_advantage)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_d12_with_advantage, **method_options).once.and_call_original
      magic.total_d12_with_advantage(**method_options)
      magic.total_d12_with_advantage
      magic.total_d12_with_advantage(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_d6_with_advantage)).to eq(true)
    end
  end
end
