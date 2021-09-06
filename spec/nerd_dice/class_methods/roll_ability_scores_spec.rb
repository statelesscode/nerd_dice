# frozen_string_literal: true

require "nerd_dice/shared_examples/an_ability_score_method_with_ability_options"
require "nerd_dice/shared_examples/an_ability_score_method_with_dice_options"
require "nerd_dice/shared_examples/an_ability_score_method_with_no_ability_options"

RSpec.shared_examples "the roll_ability_scores_method" do
  it "returns an array of DiceSets" do
    expect(result).to be_an(Array)
  end
end

RSpec.describe NerdDice, ".roll_ability_scores" do
  let(:ability_score_options) do
    {
      ability_score_array_size: 7,
      ability_score_number_of_sides: 8,
      ability_score_dice_rolled: 5,
      ability_score_dice_kept: 4
    }
  end

  let(:dice_options) do
    {
      randomization_technique: :randomized,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF"
    }
  end

  context "without options" do
    let(:result) { described_class.roll_ability_scores }
    let(:config) { described_class.configuration }

    it_behaves_like "the roll_ability_scores_method"

    it_behaves_like "an ability score method with no ability options"
  end

  context "with options on ability scores" do
    let(:result) { described_class.roll_ability_scores(**ability_score_options) }

    it_behaves_like "the roll_ability_scores_method"

    it_behaves_like "an ability score method with ability options"
  end

  context "with options on ability scores and dice" do
    let(:result) { described_class.roll_ability_scores(**ability_score_options.merge(dice_options)) }

    it_behaves_like "the roll_ability_scores_method"

    it_behaves_like "an ability score method with ability options"

    it_behaves_like "an ability score method with dice options"
  end

  context "with options on dice only" do
    let(:result) { described_class.roll_ability_scores(**dice_options) }
    let(:config) { described_class.configuration }

    it_behaves_like "the roll_ability_scores_method"

    it_behaves_like "an ability score method with no ability options"

    it_behaves_like "an ability score method with dice options"
  end

  describe "error handling" do
    it "raises an ArgumentError if you specify more dice kept than rolled" do
      expect do
        described_class.roll_ability_scores(ability_score_dice_rolled: 3, ability_score_dice_kept: 4)
      end.to raise_error(
        ArgumentError, "Argument cannot exceed number of dice"
      )
    end
  end
end
