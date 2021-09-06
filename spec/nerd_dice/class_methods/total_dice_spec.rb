# frozen_string_literal: true

require "nerd_dice/shared_examples/the_total_dice_method"

RSpec.describe NerdDice, ".total_dice" do
  context "with securerandom technique" do
    it_behaves_like "the total_dice method" do
      let(:randomization_technique) { :securerandom }
    end
  end

  context "with random_rand technique" do
    it_behaves_like "the total_dice method" do
      let(:randomization_technique) { :random_rand }
    end
  end

  context "with random_object technique" do
    it_behaves_like "the total_dice method" do
      let(:randomization_technique) { :random_object }
    end
  end

  context "with randomized technique" do
    it_behaves_like "the total_dice method" do
      let(:randomization_technique) { :randomized }
    end
  end
end
