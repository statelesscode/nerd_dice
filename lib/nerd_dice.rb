# frozen_string_literal: true

require "nerd_dice/version"

module NerdDice
  class Error < StandardError; end

  def self.total_dice(number_of_sides, number_of_dice = 1, opts = {})
    total = 0
    number_of_dice.times do
      total += rand(number_of_sides) + 1
    end
    total += opts[:bonus] if Integer === opts[:bonus]
    total
  end
end
