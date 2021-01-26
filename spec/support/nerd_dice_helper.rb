# frozen_string_literal: true

module NerdDiceHelper
  def get_different_technique(other_technique)
    techniques = NerdDice::RANDOMIZATION_TECHNIQUES.shuffle
    techniques[0] == other_technique ? techniques[1] : techniques[0]
  end
end
