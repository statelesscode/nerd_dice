# frozen_string_literal: true

RSpec.shared_examples "an ability score method with dice options" do
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
