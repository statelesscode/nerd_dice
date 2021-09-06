# frozen_string_literal: true

require "nerd_dice/shared_examples/the_execute_die_roll_method"

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

    it "returns an array of DiceSets" do
      expect(result).to be_an(Array)
    end

    it "returns the configured number of DiceSets" do
      expect(result.length).to eq(config.ability_score_array_size)
    end

    it "returns the configured number of dice in each DiceSet" do
      result.each do |dice_set|
        expect(dice_set.length).to eq(config.ability_score_dice_rolled)
      end
    end

    it "keeps the configured number of dice in each DiceSet" do
      result.each do |dice_set|
        dice_kept = 0
        dice_set.each { |die| dice_kept += 1 if die.included_in_total? }
        expect(dice_kept).to eq(config.ability_score_dice_kept)
      end
    end

    it "uses the configured number of sides on the dice" do
      result.each do |dice_set|
        dice_set.each do |die|
          expect(die.number_of_sides).to eq(config.ability_score_number_of_sides)
        end
      end
    end
  end

  context "with options on ability scores" do
    let(:result) { described_class.roll_ability_scores(**ability_score_options) }

    it "returns an array of DiceSets" do
      expect(result).to be_an(Array)
    end

    it "returns the specified number of DiceSets" do
      expect(result.length).to eq(ability_score_options[:ability_score_array_size])
    end

    it "returns the specified number of dice in each DiceSet" do
      result.each do |dice_set|
        expect(dice_set.length).to eq(ability_score_options[:ability_score_dice_rolled])
      end
    end

    it "keeps the specified number of dice in each DiceSet" do
      result.each do |dice_set|
        dice_kept = 0
        dice_set.each { |die| dice_kept += 1 if die.included_in_total? }
        expect(dice_kept).to eq(ability_score_options[:ability_score_dice_kept])
      end
    end

    it "uses the specified number of sides on the dice" do
      result.each do |dice_set|
        dice_set.each do |die|
          expect(die.number_of_sides).to eq(ability_score_options[:ability_score_number_of_sides])
        end
      end
    end
  end

  context "with options on ability scores and dice" do
    let(:result) { described_class.roll_ability_scores(**ability_score_options.merge(dice_options)) }

    it "returns an array of DiceSets" do
      expect(result).to be_an(Array)
    end

    it "returns the specified number of DiceSets" do
      expect(result.length).to eq(ability_score_options[:ability_score_array_size])
    end

    it "returns the specified number of dice in each DiceSet" do
      result.each do |dice_set|
        expect(dice_set.length).to eq(ability_score_options[:ability_score_dice_rolled])
      end
    end

    it "keeps the specified number of dice in each DiceSet" do
      result.each do |dice_set|
        dice_kept = 0
        dice_set.each { |die| dice_kept += 1 if die.included_in_total? }
        expect(dice_kept).to eq(ability_score_options[:ability_score_dice_kept])
      end
    end

    it "uses the specified number of sides on the dice" do
      result.each do |dice_set|
        dice_set.each do |die|
          expect(die.number_of_sides).to eq(ability_score_options[:ability_score_number_of_sides])
        end
      end
    end

    it "passes on specified foreground color to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.foreground_color).to eq(dice_options[:foreground_color])
      end
    end

    it "passes on specified background color to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.background_color).to eq(dice_options[:background_color])
      end
    end

    it "passes on specified randomization technique to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.randomization_technique).to eq(dice_options[:randomization_technique])
      end
    end
  end

  context "with options on dice only" do
    let(:result) { described_class.roll_ability_scores(**dice_options) }
    let(:config) { described_class.configuration }

    it "returns an array of DiceSets" do
      expect(result).to be_an(Array)
    end

    it "returns the configured number of DiceSets" do
      expect(result.length).to eq(config.ability_score_array_size)
    end

    it "returns the configured number of dice in each DiceSet" do
      result.each do |dice_set|
        expect(dice_set.length).to eq(config.ability_score_dice_rolled)
      end
    end

    it "keeps the configured number of dice in each DiceSet" do
      result.each do |dice_set|
        dice_kept = 0
        dice_set.each { |die| dice_kept += 1 if die.included_in_total? }
        expect(dice_kept).to eq(config.ability_score_dice_kept)
      end
    end

    it "uses the configured number of sides on the dice" do
      result.each do |dice_set|
        dice_set.each do |die|
          expect(die.number_of_sides).to eq(config.ability_score_number_of_sides)
        end
      end
    end

    it "passes on specified foreground color to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.foreground_color).to eq(dice_options[:foreground_color])
      end
    end

    it "passes on specified background color to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.background_color).to eq(dice_options[:background_color])
      end
    end

    it "passes on specified randomization technique to DiceSets" do
      result.each do |dice_set|
        expect(dice_set.randomization_technique).to eq(dice_options[:randomization_technique])
      end
    end
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
