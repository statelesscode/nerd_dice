# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".roll_nndnn_pn" do
  let(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  let(:method_options) do
    {
      randomization_technique: :random_rand
    }
  end

  let(:merged_options) do
    {
      randomization_technique: :random_rand,
      bonus: 6
    }
  end

  describe "roll_NdNN_pN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 3, **merged_options).and_call_original
      magic.roll_3d20_p6(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 22, bonus: 6).and_call_original
      magic.roll_22d8_p6
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:roll_dice).with(4, 1, **merged_options).and_call_original
      magic.roll_1d4_p6(**method_options)
    end

    it "defines the method after it is called" do
      magic.roll_6d100_p6(**method_options)
      expect(magic.public_methods).to include(:roll_6d100_p6)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_2d12_p6, **method_options).once.and_call_original
      magic.roll_2d12_p6(**method_options)
      magic.roll_2d12_p6
      magic.roll_2d12_p6(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_3d6_p24)).to eq(true)
    end

    it "raises error if bonus is inconsistent with kwargs" do
      expect { magic.roll_2d12_p6 bonus: 5 }.to raise_error(
        NerdDice::Error, "bonus integrity failure"
      )
    end
  end

  describe "roll_dNN_pN method" do
    it "calls NerdDice.roll_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:roll_dice).with(20, 1, **merged_options).and_call_original
      magic.roll_d20_p6(**method_options)
    end

    it "calls NerdDice.roll_dice with no keywords" do
      expect(NerdDice).to receive(:roll_dice).with(8, 1, bonus: 6).and_call_original
      magic.roll_d8_p6
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:roll_dice).with(4, 1, **merged_options).and_call_original
      magic.roll_d4_p6(**method_options)
    end

    it "defines the method after it is called" do
      magic.roll_d100_p6(**method_options)
      expect(magic.public_methods).to include(:roll_d100_p6)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:roll_d12_p6, **method_options).once.and_call_original
      magic.roll_d12_p6(**method_options)
      magic.roll_d12_p6
      magic.roll_d12_p6(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d6_p24)).to eq(true)
    end

    it "raises error if bonus is inconsistent with kwargs" do
      expect { magic.roll_d12_p6 bonus: 5 }.to raise_error(
        NerdDice::Error, "bonus integrity failure"
      )
    end
  end
end
