# frozen_string_literal: true

module NerdDice
  # The NerdDice::SetsRandomizationTechnique is a module mixin that can be included
  # in classes. It provides an attribute reader and writer for randomization_technique
  # and checks against the NerdDice::RANDOMIZATION_TECHNIQUES constant to make sure the
  # input provided is valid
  module SetsRandomizationTechnique
    attr_reader :randomization_technique

    def randomization_technique=(new_value)
      unless RANDOMIZATION_TECHNIQUES.include?(new_value) || new_value.nil?
        raise NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      end

      @randomization_technique = new_value
    end
  end
end
