# frozen_string_literal: true

#############################
# Configuration class methods
#############################
# Usage:
#   NerdDice.configure takes a block and yields the NerdDice::Configuration
#   properties:
#   If you wanted to configure several properties in a block:
#   <tt>
#     NerdDice.configure do |config|
#       config.randomization_technique = :randomized
#       config.die_background_color = "#FF0000"
#     end
#   </tt>
#
#   NerdDice.configuration returns the NerdDice::Configuration object and lets you
#   set properties on the NerdDice::Configuration object without using a block:
#   <tt>
#     config = NerdDice.configuration
#     config.randomization_technique = :randomized
#     config.die_background_color = "#FF0000"
#   </tt>
module NerdDice
  class << self
    ############################
    # configure class method
    ############################
    # Arguments: None
    # Expects and yields to a block where configuration is specified.
    # See README and NerdDice::Configuration class for config options
    # Return (NerdDice::Configuration) the Configuration object tied to the
    #   @configuration class instance variable
    def configure
      yield configuration
      configuration
    end

    ############################
    # configuration class method
    ############################
    # Arguments: None
    # Provides the lazy-loaded class instance variable @configuration
    # Return (NerdDice::Configuration) the Configuration object tied to the
    #   @configuration class instance variable
    def configuration
      @configuration ||= Configuration.new
    end
  end
end
