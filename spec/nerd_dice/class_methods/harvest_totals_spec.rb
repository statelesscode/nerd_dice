# frozen_string_literal: true

require "support/duck_type_totals"

RSpec.configure do |config|
  config.include DuckTypeTotals
end

RSpec.describe NerdDice, ".harvest_totals" do
  before { described_class.refresh_seed!(randomization_technique: :random_object, random_object_seed: 24_601) }

  let(:error_message) { "You must provide a valid collection." }

  it "returns the expected values with a collection of DiceSets" do
    dice_sets = described_class.roll_ability_scores(randomization_technique: :random_object)
    expect(described_class.harvest_totals(dice_sets)).to eq([8, 16, 13, 14, 14, 13])
  end

  it "works on a duck-typed object" do
    ducks = DuckTypeTotals::Group.new("good")
    expect(described_class.harvest_totals(ducks)).to eq([5, 5])
  end

  it "raises an error if the argument does not include Enumerable" do
    not_enumerable = NerdDice::Die.new(6)
    expect { described_class.harvest_totals(not_enumerable) }.to raise_error(
      ArgumentError, "#{error_message} Argument must respond to :map."
    )
  end

  it "raises an error if the elements do not respond to total" do
    no_totals = NerdDice::DiceSet.new(6, 3)
    expect { described_class.harvest_totals(no_totals) }.to raise_error(
      ArgumentError, "#{error_message} Each element must respond to :total."
    )
  end

  it "re-raises error if it occurs and does not involve map or total" do
    ducks = DuckTypeTotals::Group.new("bad")
    expect { described_class.harvest_totals(ducks) }.to raise_error(
      NoMethodError, /undefined method [`']foo'/
    )
  end
end
