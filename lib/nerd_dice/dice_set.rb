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
    include SetsRandomizationTechnique

    attr_reader :number_of_sides, :number_of_dice, :dice, :bonus
    attr_accessor :background_color, :foreground_color, :damage_type

    # required to implement Enumerable uses the @dice collection
    def each(&block)
      @dice.each(&block)
    end

    # not included by default in Enumerable: allows [] directly on the DiceSet object
    def [](index)
      @dice[index]
    end

    # not included by default in Enumerable: adds length property directly to the DiceSet object
    def length
      @dice.length
    end

    # sorts the @dice collection in place
    def sort!
      @dice.sort!
    end

    # reverses the @dice collection in place
    def reverse!
      @dice.reverse!
    end

    # re-rolls each Die in the collection and sets its is_included_in_total property back to true
    def reroll_all!
      @dice.map do |die|
        die.roll
        die.is_included_in_total = true
      end
    end

    # resets is_included_in_total property back to true for each Die in the collection
    def include_all_dice!
      @dice.map { |die| die.is_included_in_total = true }
    end

    ###################################
    # highest instance method
    # (aliased as with_advantage)
    ###################################
    # Arguments:
    #   number_to_take (Integer default: nil) =>  the number dice to take
    #
    # Notes:
    # * If the method is called with a nil value it will take all but one of the dice
    # * If the method is called on a DiceSet with one Die, the lone Die will remain included
    # * The method will raise an ArgumentError if you try to take more dice than the DiceSet contains
    # * Even though this method doesn't have a bang at the end, it does call other bang methods
    #
    # Return (NerdDice::DiceSet) => Returns the instance the method was called on with
    # die objects that have is_included_in_total property modified as true for the highest(n)
    # dice and false for the remaining dice.
    def highest(number_to_take = nil)
      include_all_dice!
      number_to_take = check_low_high_argument!(number_to_take)
      get_default_to_take if number_to_take.nil?
      @dice.sort.reverse.each_with_index do |die, index|
        die.is_included_in_total = false if index >= number_to_take
      end
      self
    end

    alias with_advantage highest

    ###################################
    # lowest instance method
    # (aliased as with_disadvantage)
    ###################################
    # Arguments and Notes are the same as for the highest method documented above
    #
    # Return (NerdDice::DiceSet) => Returns the instance the method was called on with
    # die objects that have is_included_in_total property modified as true for the lowest(n)
    # dice and false for the remaining dice.
    def lowest(number_to_take = nil)
      include_all_dice!
      number_to_take = check_low_high_argument!(number_to_take)
      get_default_to_take if number_to_take.nil?
      @dice.sort.each_with_index do |die, index|
        die.is_included_in_total = false if index >= number_to_take
      end
      self
    end

    alias with_disadvantage lowest

    # custom attribute writer that ensures the argument is an Integer duck-type and calls to_i
    def bonus=(new_value)
      @bonus = new_value.to_i
    rescue NoMethodError
      raise ArgumentError, "Bonus must be a value that responds to :to_i"
    end

    ###################################
    # total method
    ###################################
    # Return (Integer) => Returns the sum of the values on the Die objects in the collection
    # where is_included_in_total is set to true and then adds the value of the bonus
    # attribute (which may be negative)
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
        self.bonus = opts[:bonus]
      end

      # validates the argument input to the highest and lowest methods
      # sets a default value if number_to_take is nil
      def check_low_high_argument!(number_to_take)
        number_to_take ||= number_of_dice == 1 ? 1 : number_of_dice - 1
        raise ArgumentError, "Argument cannot exceed number of dice" if number_to_take > number_of_dice

        number_to_take
      end
  end
end
