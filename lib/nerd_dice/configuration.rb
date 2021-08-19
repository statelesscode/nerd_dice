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
    attr_reader :randomization_technique, :refresh_seed_interval
    attr_accessor :ability_score_array_size, :die_background_color, :die_foreground_color

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

    private

      def initialize
        @ability_score_array_size = 6
        @randomization_technique = :random_object
        @die_background_color = DEFAULT_BACKGROUND_COLOR
        @die_foreground_color = DEFAULT_FOREGROUND_COLOR
      end
  end
end
