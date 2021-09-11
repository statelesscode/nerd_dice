# frozen_string_literal: true

RSpec.describe NerdDice, ".total_ability_scores" do
  before do
    described_class.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1_337)
  end

  context "with options" do
    let(:method_options) do
      {
        ability_score_array_size: 7,
        ability_score_number_of_sides: 8,
        ability_score_dice_rolled: 5,
        ability_score_dice_kept: 4,
        randomization_technique: :random_rand,
        foreground_color: "#FF0000",
        background_color: "#FFFFFF"
      }
    end

    it "passes options on to roll_ability_scores" do
      expect(described_class).to receive(:roll_ability_scores).with(**method_options).and_call_original
      described_class.total_ability_scores(**method_options)
    end

    it "returns expected values from options" do
      expect(described_class.total_ability_scores(**method_options)).to eq([27, 17, 21, 17, 23, 13, 27])
    end
  end

  context "without options" do
    before do
      described_class.instance_variable_set(:@configuration, NerdDice::Configuration.new)
      described_class.configuration.randomization_technique = :random_rand
    end

    it "returns expected values" do
      expect(described_class.total_ability_scores).to eq([13, 11, 6, 13, 9, 11])
    end
  end
end
