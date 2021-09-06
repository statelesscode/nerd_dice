# frozen_string_literal: true

RSpec.shared_examples "an ability score method with ability options" do
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
