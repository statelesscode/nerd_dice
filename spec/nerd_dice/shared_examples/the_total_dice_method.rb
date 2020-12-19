# frozen_string_literal: true

RSpec.shared_examples "the total_dice method" do
  before { NerdDice.configuration.randomization_technique = randomization_technique }

  let(:sample_size) { 200 }
  context "with no options" do
    it "calculates the dice total correctly for a single die" do
      sample_size.times do
        result = described_class.total_dice(6)
        expect(result).to be_between(1, 6)
      end
    end

    it "calculates the dice total correctly for a multiple dice" do
      sample_size.times do
        result = described_class.total_dice(6, 3)
        expect(result).to be_between(3, 18)
      end
    end
  end

  context "with options" do
    it "calculates with a positive bonus correctly" do
      sample_size.times do
        result = described_class.total_dice(6, 3, { bonus: 2 })
        expect(result).to be_between(5, 20)
      end
    end

    it "calculates with a zero bonus correctly" do
      sample_size.times do
        result = described_class.total_dice(6, 3, { bonus: 0 })
        expect(result).to be_between(3, 18)
      end
    end

    it "calculates with a negative penalty correctly" do
      sample_size.times do
        result = described_class.total_dice(6, 3, { bonus: -5 })
        expect(result).to be_between(-2, 13)
      end
    end

    it "ignores non-integer bonus correctly" do
      sample_size.times do
        result = described_class.total_dice(6, 3, { bonus: "foo" })
        expect(result).to be_between(3, 18)
      end
    end

    it "handles one die" do
      sample_size.times do
        result = described_class.total_dice(6, 1, { bonus: 2 })
        expect(result).to be_between(2, 8)
      end
    end
  end
end
