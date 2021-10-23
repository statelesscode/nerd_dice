# frozen_string_literal: true

# total_dNN_with_advantage pattern spec
# Covers situation pattern of /total_d\d+_with_advantage/ with no number to keep specified
# * Rolls 2 dice and keeps the highest
# * Returns an Integer by calling NerdDice.roll_dice().highest().total
# * Specs cover keywords, use of method without keywords, testing method defined and errors
# * Examples
#   * total_d20_with_advantage => roll 2 d20 and take the highest
#   * total_d8_with_advantage_plus6 => roll 2 d8 and take the highest then add 6
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

  # combine with bonuses and penalties
  describe "total_dNN_with_advantage with bonuses and penalties" do
    it "calls calls NerdDice.roll_dice with correct arguments, keywords with bonus" do
      merged_options = method_options.merge(bonus: 6)
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **merged_options).and_call_original
      magic.total_d20_with_advantage_plus6(**method_options)
    end

    it "calls calls NerdDice.roll_dice with correct arguments, keywords with penalty" do
      merged_options = method_options.merge(bonus: -5)
      expect(NerdDice).to receive(:roll_dice).with(20, 2, **merged_options).and_call_original
      magic.total_d20_with_advantage_m5(**method_options)
    end

    it "raises error if bonus or penalty does not match the keyword argument" do
      expect { magic.total_d20_with_advantage_minus4 bonus: 5 }.to raise_error(
        NerdDice::Error, /#{get_bonus_error_message(5, -4)}/
      )
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:total_d20_with_advantage_minus4)).to eq(true)
    end
  end
end
