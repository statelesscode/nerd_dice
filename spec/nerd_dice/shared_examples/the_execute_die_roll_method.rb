# frozen_string_literal: true

RSpec.shared_examples "the execute_die_roll method" do
  before { NerdDice.configuration.randomization_technique = :random_rand }

  let(:sample_size) { 200 }
  it "calculates the die total correctly" do
    sample_size.times do
      result = described_class.execute_die_roll(20, using_generator)
      expect(result).to be_between(1, 20)
    end
  end
end
