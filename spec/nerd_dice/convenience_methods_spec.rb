# frozen_string_literal: true

RSpec.describe NerdDice::ConvenienceMethods do
  subject(:magic) { Class.new { extend NerdDice::ConvenienceMethods } }

  describe "standard method_missing behavior" do
    it "still raises NoMethodError if method is not defined and does not match patterns" do
      expect { magic.taxation_is_theft! }.to raise_error(
        NoMethodError, /undefined method [`']taxation_is_theft!' for /
      )
    end

    it "raises NoMethodError if improper combination of patterns with total" do
      expect { magic.total_4d6_lowest3_highest2 }.to raise_error(
        NoMethodError, /undefined method [`']total_4d6_lowest3_highest2' for /
      )
    end

    it "raises NoMethodError if improper combination of patterns with roll" do
      expect { magic.roll_d20_with_advantage_lowest }.to raise_error(
        NoMethodError, /undefined method [`']roll_d20_with_advantage_lowest' for /
      )
    end

    it "responds to methods matching the pattern" do
      expect(magic.respond_to?(:roll_d10)).to be(true)
    end

    it "does not respond to methods that do not match the pattern" do
      expect(magic.respond_to?(:taxation_is_theft!)).to be(false)
    end
  end
end
