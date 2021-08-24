# frozen_string_literal: true

RSpec.describe NerdDice::Die do
  subject(:die) { described_class.new(20) }

  context "without instantiation options" do
    it "sets the number of sides from the first argument" do
      expect(die.number_of_sides).to eq(20)
    end

    it "has expected default randomization_technique of nil" do
      expect(die.randomization_technique).to be_nil
    end

    it "has expected default foreground_color of #DDDDDD" do
      expect(die.foreground_color).to eq("#DDDDDD")
    end

    it "has expected default background_color of #0000DD" do
      expect(die.background_color).to eq("#0000DD")
    end

    it "has a damage_type of nil" do
      expect(die.damage_type).to be_nil
    end

    it "has a value between 1 and number of sides" do
      expect(die.value).to be_between(1, 20)
    end

    it "has a included_in_total? of true" do
      expect(die.is_included_in_total).to be(true)
    end
  end

  context "with instantiation options" do
    let(:die_with_options) do
      described_class.new(12,
                          randomization_technique: :randomized,
                          foreground_color: "#FF0000",
                          background_color: "#FFFFFF",
                          damage_type: "fire")
    end

    it "sets the number of sides from the first argument" do
      expect(die_with_options.number_of_sides).to eq(12)
    end

    it "applies the randomization_technique from options" do
      expect(die_with_options.randomization_technique).to eq(:randomized)
    end

    it "applies the provided foreground_color of #FF0000" do
      expect(die_with_options.foreground_color).to eq("#FF0000")
    end

    it "applies the provided background_color of #FFFFFF" do
      expect(die_with_options.background_color).to eq("#FFFFFF")
    end

    it "applies the provided damage_type of fire" do
      expect(die_with_options.damage_type).to eq("fire")
    end

    it "has a value between 1 and number of sides" do
      expect(die_with_options.value).to be_between(1, 12)
    end

    it "has a included_in_total? of true" do
      expect(die.is_included_in_total).to be(true)
    end
  end

  describe "roll method" do
    let(:original_value) { die.value }

    # rubocop:disable RSpec/ExampleLength
    it "replaces the value of the die" do
      changed = false
      5.times do
        die.roll
        changed = true if die.value != original_value
      end
      expect(changed).to eq(true)
    end
    # rubocop:enable RSpec/ExampleLength

    it "has the correct range" do
      5.times do
        die.roll
        expect(die.value).to be_between(1, 20)
      end
    end

    it "returns the new value" do
      roll_value = die.roll
      expect(roll_value).to eq(die.value)
    end
  end

  describe "setting included_in_total? attribute" do
    it "can be set to false" do
      die.is_included_in_total = false
      expect(die.included_in_total?).to be(false)
    end

    it "can be set to true" do
      die.is_included_in_total = false
      die.is_included_in_total = true
      expect(die.included_in_total?).to be(true)
    end
  end

  describe "error handling" do
    it "raises error if bad randomization_technique provided" do
      expect { described_class.new(6, randomization_technique: :invalid) }.to raise_error(
        NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      )
    end
  end

  describe "comparable_methods" do
    before { NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337) }

    let(:die1) { described_class.new 6, randomization_technique: :random_rand }
    let(:die2) { described_class.new 100, randomization_technique: :random_rand }
    let(:die3) { described_class.new 1 }
    let(:die4) { described_class.new 1 }

    it "has working > method" do
      expect(die2 > die1).to be(true)
    end

    it "has working < method" do
      expect(die1 < die2).to be(true)
    end

    it "has working == method for unequal" do
      expect(die1 == die2).to be(false)
    end

    it "has working == method for equal" do
      expect(die3 == die4).to be(true)
    end
  end
end
