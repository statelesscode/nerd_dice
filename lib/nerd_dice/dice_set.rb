# frozen_string_literal: true

module NerdDice
  # The NerdDice::DiceSet class allows you to instantiate and roll a set of dice by specifying
  # the number of sides, the number of dice (with a default of 1) and other options. As part of
  # initialization the DiceSet will initialize and roll the Die objects specified by the
  # DiceSet.new method. The parameters align with the NerdDice.total_dice method and
  # NerdDice::DiceSet.new(6, 3, bonus: 5).total would be equivalent to
  # NerdDice.total_dice(6, 3, bonus: 5)
  #
  # Usage:
  #   Instantiate a d20:
  #   <tt>dice = NerdDice::DiceSet.new(20)
  #       dice.total # between 1 and 20
  #   </tt>
  #
  #   Instantiate 3d6 + 5:
  #   <tt>dice = NerdDice::DiceSet.new(6, 3, bonus: 5)
  #       dice.total # between 8 and 23
  #   </tt>
  #
  #   You can also specify options that will cascade to the member dice when instantiating
  #   <tt>NerdDice::DiceSet.new(6, 3, randomization_technique: :randomized,
  #                        foreground_color: "#FF0000",
  #                        background_color: "#FFFFFF"
  #                        damage_type: "necrotic"))
  #   </tt>
  class DiceSet
    include Enumerable

    attr_reader :number_of_sides, :number_of_dice, :randomization_technique, :dice, :bonus
    attr_accessor :background_color, :foreground_color, :damage_type

    def each(&block)
      @dice.each(&block)
    end

    def [](index)
      @dice[index]
    end

    def length
      @dice.length
    end

    def reroll_all
      @dice.map(&:roll)
    end

    def highest(number_to_take = nil)
      number_to_take = check_low_high_argument!(number_to_take)
      get_default_to_take if number_to_take.nil?
      @dice.sort.reverse.each_with_index do |die, index|
        die.is_included_in_total = false if index >= number_to_take
      end
      self
    end

    alias with_advantage highest

    def lowest(number_to_take = nil)
      number_to_take = check_low_high_argument!(number_to_take)
      get_default_to_take if number_to_take.nil?
      @dice.sort.each_with_index do |die, index|
        die.is_included_in_total = false if index >= number_to_take
      end
      self
    end

    alias with_disadvantage lowest

    def randomization_technique=(new_value)
      unless RANDOMIZATION_TECHNIQUES.include?(new_value) || new_value.nil?
        raise NerdDice::Error, "randomization_technique must be one of #{NerdDice::RANDOMIZATION_TECHNIQUES.join(', ')}"
      end

      @randomization_technique = new_value
    end

    def total
      @dice.select(&:included_in_total?).sum(&:value) + @bonus
    end

    private

      def initialize(number_of_sides, number_of_dice = 1, **opts)
        @number_of_sides = number_of_sides
        @number_of_dice = number_of_dice
        parse_options(opts)
        @dice = []
        @number_of_dice.times { @dice << Die.new(@number_of_sides, **opts) }
      end

      def parse_options(opts)
        self.randomization_technique = opts[:randomization_technique]
        @background_color = opts[:background_color] || NerdDice.configuration.die_background_color
        @foreground_color = opts[:foreground_color] || NerdDice.configuration.die_foreground_color
        @damage_type = opts[:damage_type]
        begin
          @bonus = opts[:bonus].to_i
        rescue NoMethodError
          raise ArgumentError, "Bonus must be a value that responds to :to_i"
        end
      end

      def check_low_high_argument!(number_to_take)
        number_to_take ||= number_of_dice == 1 ? 1 : number_of_dice - 1
        raise ArgumentError, "Argument cannot exceed number of dice" if number_to_take > number_of_dice

        number_to_take
      end
  end
end
