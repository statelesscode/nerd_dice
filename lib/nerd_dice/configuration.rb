# frozen_string_literal: true

module NerdDice
  # The NerdDice::Configuration class allows you to configure and customize the
  # options of the NerdDice gem to suit your specific needs. You can specify
  # properties like the randomization technique used by the gem, the number of
  # ability scores in an ability score array, etc. See the README for a list of
  # configurable attributes.
  #
  # Usage:
  #   The configuration can either be set via a configure block:
  #   <tt>NerdDice.configure do |config|
  #         config.randomization_technique = :random_new_interval
  #         config.new_random_interval     = 100
  #       end
  #   </tt>
  #
  #   You can also set a particular property without a block using inline assignment
  #   <tt>NerdDice.configuration.randomization_technique = :random_new_once</tt>
  class Configuration
    attr_reader :randomization_technique, :refresh_seed_interval, :ability_score_array_size,
                :ability_score_dice_rolled, :ability_score_number_of_sides, :ability_score_dice_kept
    attr_accessor :die_background_color, :die_foreground_color

    DEFAULT_BACKGROUND_COLOR = "#0000DD"
    DEFAULT_FOREGROUND_COLOR = "#DDDDDD"

    def randomization_technique=(value)
      unless RANDOMIZATION_TECHNIQUES.include?(value)
        raise NerdDice::Error, "randomization_technique must be one of #{RANDOMIZATION_TECHNIQUES.join(', ')}"
      end

      @randomization_technique = value
    end

    def refresh_seed_interval=(value)
      unless value.nil?
        value = value&.to_i
        raise NerdDice::Error, "refresh_seed_interval must be a positive integer or nil" unless value.positive?
      end
      @refresh_seed_interval = value
    end

    def ability_score_array_size=(value)
      @ability_score_array_size = ensure_positive_integer!("ability_score_array_size", value)
    end

    def ability_score_number_of_sides=(value)
      @ability_score_number_of_sides = ensure_positive_integer!("ability_score_number_of_sides", value)
    end

    def ability_score_dice_rolled=(value)
      @ability_score_dice_rolled = ensure_positive_integer!("ability_score_dice_rolled", value)
      return unless ability_score_dice_kept > @ability_score_dice_rolled

      warn "WARNING: ability_score_dice_rolled set to lower value than ability_score_dice_kept. " \
           "Reducing ability_score_dice_kept from #{ability_score_dice_kept} to #{@ability_score_dice_rolled}"
      self.ability_score_dice_kept = @ability_score_dice_rolled
    end

    def ability_score_dice_kept=(value)
      compare_error_message = "cannot set ability_score_dice_kept greater than ability_score_dice_rolled"
      new_value = ensure_positive_integer!("ability_score_dice_kept", value)
      raise NerdDice::Error, compare_error_message if new_value > @ability_score_dice_rolled

      @ability_score_dice_kept = new_value
    end

    private

      def initialize
        @ability_score_array_size = 6
        @ability_score_number_of_sides = 6
        @ability_score_dice_rolled = 4
        @ability_score_dice_kept = 3
        @randomization_technique = :random_object
        @die_background_color = DEFAULT_BACKGROUND_COLOR
        @die_foreground_color = DEFAULT_FOREGROUND_COLOR
      end

      def ensure_positive_integer!(attribute_name, argument_value)
        error_message = "#{attribute_name} must be must be a positive value that responds to :to_i"
        new_value = argument_value.to_i
        raise ArgumentError, error_message unless new_value.positive?

        new_value
      rescue NoMethodError
        raise ArgumentError, error_message
      end
  end
end
