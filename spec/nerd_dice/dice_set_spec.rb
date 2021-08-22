# frozen_string_literal: true

RSpec.describe NerdDice::DiceSet do
  subject(:dice_set) { described_class.new(6, 3) }

  let(:dice_options) do
    {
      randomization_technique: :randomized,
      foreground_color: "#FF0000",
      background_color: "#FFFFFF",
      damage_type: "fire",
      bonus: 5
    }
  end

  context "with one die and no options" do
    let(:one_die) { described_class.new(20) }

    it "sets the number of sides from the first argument" do
      expect(one_die.number_of_sides).to eq(20)
    end

    it "has the default number of dice equal to 1" do
      expect(one_die.number_of_dice).to eq(1)
    end

    it "has expected randomization technique of nil" do
      expect(one_die.randomization_technique).to be_nil
    end

    it "has expected default foreground_color of #DDDDDD" do
      expect(one_die.foreground_color).to eq("#DDDDDD")
    end

    it "has expected default background_color of #0000DD" do
      expect(one_die.background_color).to eq("#0000DD")
    end

    it "has a damage_type of nil" do
      expect(one_die.damage_type).to be_nil
    end

    it "has a total between 1 and number of sides" do
      expect(one_die.total).to be_between(1, 20)
    end

    it "has a dice property with a length of 1" do
      expect(one_die.length).to eq(1)
    end

    it "has an element in dice that is a Die object" do
      expect(one_die[0]).to be_a(NerdDice::Die)
    end
  end

  context "with three dice and no options" do
    it "sets the number of sides from the first argument" do
      expect(dice_set.number_of_sides).to eq(6)
    end

    it "sets the number of dice from the second argument" do
      expect(dice_set.number_of_dice).to eq(3)
    end

    it "has expected randomization technique of nil" do
      expect(dice_set.randomization_technique).to be_nil
    end

    it "has expected default foreground_color of #DDDDDD" do
      expect(dice_set.foreground_color).to eq("#DDDDDD")
    end

    it "has expected default background_color of #0000DD" do
      expect(dice_set.background_color).to eq("#0000DD")
    end

    it "has a damage_type of nil" do
      expect(dice_set.damage_type).to be_nil
    end

    it "has a total between number of dice and dice times sides" do
      expect(dice_set.total).to be_between(3, 18)
    end

    it "has a dice property with a length equal to number of dice" do
      expect(dice_set.length).to eq(3)
    end

    it "has elements in dice that are all Die objects" do
      expect(dice_set).to all(be_a(NerdDice::Die))
    end
  end

  context "with one die and instantiation options" do
    let(:one_die_with_options) { described_class.new(12, **dice_options) }

    it "sets the number of sides from the first argument" do
      expect(one_die_with_options.number_of_sides).to eq(12)
    end

    it "has the default number of dice equal to 1" do
      expect(one_die_with_options.number_of_dice).to eq(1)
    end

    it "applies the randomization technique from options" do
      expect(one_die_with_options.randomization_technique).to eq(:randomized)
    end

    it "applies the provided foreground_color of #FF0000" do
      expect(one_die_with_options.foreground_color).to eq("#FF0000")
    end

    it "applies the provided background_color of #FFFFFF" do
      expect(one_die_with_options.background_color).to eq("#FFFFFF")
    end

    it "applies the provided damage_type of fire" do
      expect(one_die_with_options.damage_type).to eq("fire")
    end

    it "has a total between 1 and number of sides plus bonus" do
      # includes bonus
      expect(one_die_with_options.total).to be_between(6, 17)
    end

    it "has a dice property with a length of 1" do
      expect(one_die_with_options.length).to eq(1)
    end

    it "has an element in dice that is a Die object" do
      expect(one_die_with_options[0]).to be_a(NerdDice::Die)
    end

    it "applies randomization_technique to die object" do
      die = one_die_with_options[0]
      expect(die.randomization_technique).to eq(:randomized)
    end

    it "applies foreground_color to die object" do
      die = one_die_with_options[0]
      expect(die.foreground_color).to eq("#FF0000")
    end

    it "applies background_color to die object" do
      die = one_die_with_options[0]
      expect(die.background_color).to eq("#FFFFFF")
    end

    it "applies damage_type to die object" do
      die = one_die_with_options[0]
      expect(die.damage_type).to eq("fire")
    end
  end

  context "with three dice and instantiation options" do
    let(:three_dice_with_options) { described_class.new(6, 3, **dice_options) }

    it "sets the number of sides from the first argument" do
      expect(three_dice_with_options.number_of_sides).to eq(6)
    end

    it "sets the number of dice from the second argument" do
      expect(three_dice_with_options.number_of_dice).to eq(3)
    end

    it "applies the randomization technique from options" do
      expect(three_dice_with_options.randomization_technique).to eq(:randomized)
    end

    it "applies the provided foreground_color of #FF0000" do
      expect(three_dice_with_options.foreground_color).to eq("#FF0000")
    end

    it "applies the provided background_color of #FFFFFF" do
      expect(three_dice_with_options.background_color).to eq("#FFFFFF")
    end

    it "applies the provided damage_type of fire" do
      expect(three_dice_with_options.damage_type).to eq("fire")
    end

    it "has a total between number of dice and dice times sides plus bonus" do
      # includes bonus
      expect(three_dice_with_options.total).to be_between(8, 23)
    end

    it "has a dice property with a length equal to number of dice" do
      expect(three_dice_with_options.length).to eq(3)
    end

    it "has elements in dice that are all Die objects" do
      expect(three_dice_with_options).to all(be_a(NerdDice::Die))
    end

    it "applies randomization_technique to all dice" do
      three_dice_with_options.each do |die|
        expect(die.randomization_technique).to eq(:randomized)
      end
    end

    it "applies foreground_color to all dice" do
      three_dice_with_options.each do |die|
        expect(die.foreground_color).to eq("#FF0000")
      end
    end

    it "applies background_color to all dice" do
      three_dice_with_options.each do |die|
        expect(die.background_color).to eq("#FFFFFF")
      end
    end

    it "applies damage_type to to all dice" do
      three_dice_with_options.each do |die|
        expect(die.damage_type).to eq("fire")
      end
    end
  end

  describe "error handling" do
    it "raises error if bad randomization_technique provided" do
      expect { described_class.new(6, 3, randomization_technique: :invalid) }.to raise_error(
        NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      )
    end

    it "raises error if bad bonus provided" do
      expect { described_class.new(6, 3, bonus: :flump) }.to raise_error(
        ArgumentError, "Bonus must be a value that responds to :to_i"
      )
    end
  end

  describe "the reroll_all method" do
    before { NerdDice.refresh_seed!(randomization_technique: :random_rand, random_rand_seed: 1337) }

    let(:dice) { described_class.new 6, 3, randomization_technique: :random_rand }

    it "changes the total" do
      expect { dice.reroll_all }.to change(dice, :total)
    end

    it "changes the first die" do
      expect { dice.reroll_all }.to change(dice[0], :value)
    end

    it "changes the second die" do
      expect { dice.reroll_all }.to change(dice[1], :value)
    end

    it "changes the third die" do
      expect { dice.reroll_all }.to change(dice[2], :value)
    end
  end
end
