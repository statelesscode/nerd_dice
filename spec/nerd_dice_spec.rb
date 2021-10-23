# frozen_string_literal: true

RSpec.describe NerdDice do
  it "has a version number" do
    expect(NerdDice::VERSION).not_to be nil
  end

  it "can be configured" do
    described_class.configure do |config|
      config.ability_score_array_size = 7 # default 6
    end

    expect(described_class.configuration.ability_score_array_size).to eq(7)
  end

  it "configure returns the configuration object" do
    result = described_class.configure do |config|
      config.ability_score_array_size = 7 # default 6
    end

    expect(result).to eq(described_class.configuration)
  end

  describe "ConvenienceMethods mixin as class methods" do
    let(:method_options) do
      {
        randomization_technique: :random_rand,
        foreground_color: "#FF0000",
        background_color: "#FFFFFF"
      }
    end

    describe "roll_ class methods" do
      it "calls NerdDice.roll_dice with correct arguments and keywords" do
        expect(described_class).to receive(:roll_dice).with(20, 3, **method_options).and_call_original
        described_class.roll_3d20(**method_options)
      end

      it "calls NerdDice.roll_dice with no keywords" do
        expect(described_class).to receive(:roll_dice).with(8, 22).and_call_original
        described_class.roll_22d8
      end

      it "works if you specify 1dNN" do
        expect(described_class).to receive(:roll_dice).with(4, 1, **method_options).and_call_original
        described_class.roll_1d4(**method_options)
      end

      it "defines the method after it is called" do
        described_class.roll_6d100(**method_options)
        expect(described_class.public_methods).to include(:roll_6d100)
      end

      it "handles subsequent calls without calling method_missing" do
        expect(described_class).to receive(:method_missing).with(:roll_2d12, **method_options).once.and_call_original
        described_class.roll_2d12(**method_options)
        described_class.roll_2d12
        described_class.roll_2d12(**method_options)
      end

      it "responds to methods matching the pattern" do
        expect(described_class.respond_to?(:roll_3d6)).to eq(true)
      end
    end

    describe "total_ class methods" do
      it "calls NerdDice.total_dice with correct arguments and keywords" do
        expect(described_class).to receive(:total_dice).with(20, 3, **method_options).and_call_original
        described_class.total_3d20(**method_options)
      end

      it "calls NerdDice.total_dice with no keywords" do
        expect(described_class).to receive(:total_dice).with(8, 22).and_call_original
        described_class.total_22d8
      end

      it "works if you specify 1dNN" do
        expect(described_class).to receive(:total_dice).with(4, 1, **method_options).and_call_original
        described_class.total_1d4(**method_options)
      end

      it "defines the method after it is called" do
        described_class.total_6d100(**method_options)
        expect(described_class.public_methods).to include(:total_6d100)
      end

      it "handles subsequent calls without calling method_missing" do
        expect(described_class).to receive(:method_missing).with(:total_2d12, **method_options).once.and_call_original
        described_class.total_2d12(**method_options)
        described_class.total_2d12
        described_class.total_2d12(**method_options)
      end

      it "responds to methods matching the pattern" do
        expect(described_class.respond_to?(:total_3d6)).to eq(true)
      end
    end
  end
end
