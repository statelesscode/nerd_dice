# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods, ".total_nndnn_pn" do
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

  describe "total_dNN method" do
    it "calls NerdDice.total_dice with correct arguments and keywords" do
      expect(NerdDice).to receive(:total_dice).with(20, 3, **merged_options).and_call_original
      magic.total_3d20_p6(**method_options)
    end

    it "calls NerdDice.total_dice with no keywords" do
      expect(NerdDice).to receive(:total_dice).with(8, 22, bonus: 6).and_call_original
      magic.total_22d8_p6
    end

    it "works if you specify 1dNN" do
      expect(NerdDice).to receive(:total_dice).with(4, 1, **merged_options).and_call_original
      magic.total_1d4_p6(**method_options)
    end

    it "defines the method after it is called" do
      magic.total_6d100_p6(**method_options)
      expect(magic.public_methods).to include(:total_6d100_p6)
    end

    it "handles subsequent calls without calling method_missing" do
      expect(magic).to receive(:method_missing).with(:total_2d12_p6, **method_options).once.and_call_original
      magic.total_2d12_p6(**method_options)
      magic.total_2d12_p6
      magic.total_2d12_p6(**method_options)
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_3d6_p24)).to eq(true)
    end

    it "raises error if bonus is inconsistent with kwargs" do
      expect { magic.total_2d12_p6 bonus: 5 }.to raise_error(
        NerdDice::Error, "bonus integrity failure"
      )
    end
  end
end
