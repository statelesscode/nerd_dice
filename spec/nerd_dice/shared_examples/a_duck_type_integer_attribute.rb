# frozen_string_literal: true

RSpec.shared_examples "a positive duck type integer attribute writer" do
  let(:error_message) { "#{attribute_name} must be must be a positive value that responds to :to_i" }

  it "allows you to set a new value" do
    config.send("#{attribute_name}=", 4)
    expect(config.send(attribute_name)).to eq(4)
  end

  it "allows you to provide a numeric string" do
    config.send("#{attribute_name}=", "3")
    expect(config.send(attribute_name)).to eq(3)
  end

  describe "error handling" do
    it "throws an ArgumentError if new value does not respond to to_i" do
      expect { config.send("#{attribute_name}=", :threeve) }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value does not convert to positive integer" do
      expect { config.send("#{attribute_name}=", "eleventy-billion") }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is 0" do
      expect { config.send("#{attribute_name}=", 0) }.to raise_error(ArgumentError, error_message)
    end

    it "throws an ArgumentError if new value is a negative Integer" do
      expect { config.send("#{attribute_name}=", -6) }.to raise_error(ArgumentError, error_message)
    end
  end
end
