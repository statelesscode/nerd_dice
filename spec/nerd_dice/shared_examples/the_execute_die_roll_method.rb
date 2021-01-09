# frozen_string_literal: true

RSpec.shared_examples "the execute_die_roll method" do
  before do
    NerdDice.configuration.randomization_technique = :random_rand
    described_class.configuration.refresh_seed_interval = nil
  end

  let(:sample_size) { 200 }
  it "calculates the die total correctly" do
    sample_size.times do
      result = described_class.execute_die_roll(20, using_generator)
      expect(result).to be_between(1, 20)
    end
  end

  it "increments count_since_last_refresh if inititally nil" do
    described_class.instance_variable_set(:@count_since_last_refresh, nil)
    described_class.execute_die_roll(20, using_generator)
    expect(described_class.count_since_last_refresh).to eq(1)
  end

  it "increments count_since_last_refresh if Integer" do
    described_class.instance_variable_set(:@count_since_last_refresh, 5)
    described_class.execute_die_roll(20, using_generator)
    expect(described_class.count_since_last_refresh).to eq(6)
  end

  # rubocop:disable RSpec/MessageSpies
  context "with nil refresh_seed_interval" do
    it "does not call refresh_seed!" do
      described_class.configuration.refresh_seed_interval = nil
      expect(described_class).not_to receive(:refresh_seed!)
      sample_size.times do
        described_class.execute_die_roll(20, using_generator)
      end
    end
  end

  context "with a non-nil refresh seed and interval not reached" do
    it "does not refresh the seed" do
      described_class.configuration.refresh_seed_interval = 7
      described_class.instance_variable_set(:@count_since_last_refresh, 5)
      expect(described_class).not_to receive(:refresh_seed!)
      described_class.execute_die_roll(20, using_generator)
    end
  end

  context "with a non-nil refresh seed and interval reached" do
    before do
      described_class.configuration.refresh_seed_interval = 6
      described_class.instance_variable_set(:@count_since_last_refresh, 5)
    end

    it "refreshes the seed" do
      expect(described_class).to receive(:refresh_seed!).once
      described_class.execute_die_roll(20, using_generator)
    end

    it "resets the counter" do
      described_class.execute_die_roll(20, using_generator)
      expect(described_class.count_since_last_refresh).to eq(0)
    end
  end
  # rubocop:enable RSpec/MessageSpies
end
