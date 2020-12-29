# frozen_string_literal: true

require "nerd_dice/shared_examples/the_execute_die_roll_method"

RSpec.describe NerdDice, ".execute_die_roll" do
  context "with securerandom technique" do
    it_behaves_like "the execute_die_roll method" do
      let(:using_generator) { :securerandom }
    end
  end

  context "with random_rand technique" do
    it_behaves_like "the execute_die_roll method" do
      let(:using_generator) { :random_rand }
    end
  end

  context "with random_object technique" do
    it_behaves_like "the execute_die_roll method" do
      let(:using_generator) { :random_object }
    end
  end

  context "with randomized technique" do
    it_behaves_like "the execute_die_roll method" do
      let(:using_generator) { :randomized }
    end
  end

  context "with nil technique" do
    it_behaves_like "the execute_die_roll method" do
      let(:using_generator) { nil }
    end
  end

  it "errors out if invalid using_generator argument is provided" do
    expect { described_class.execute_die_roll(20, :malicious_generator) }
      .to raise_error(
        "Unrecognized generator. Must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      )
  end
end
