# frozen_string_literal: true

############################
# harvest_totals method
############################
# Usage:
#   This method will take any collection of objects where each element responds to
#   :total and return an array of the results of the total method.
#
#   Example
#   <tt>
#     ability_score_array = NerdDice.roll_ability_scores
#     => Array of 6 DiceSet objects
#     totals_array = NerdDice.harvest_totals(totals_array)
#     => [15, 14, 13, 12, 10, 8]
#     # yes, it just happened to be the standard array by amazing coincidence
#   </tt>
module NerdDice
  class << self
    # Arguments:
    #   collection (Enumerable) a collection where each element responds to total
    #
    # Return (Array) => Data type of each element will be whatever is returned by total method
    def harvest_totals(collection)
      collection.map(&:total)
    rescue NoMethodError => e
      specific_message = get_harvest_totals_error_message(e)
      specific_message ? raise(ArgumentError, "You must provide a valid collection. #{specific_message}") : raise
    end

    private

      def get_harvest_totals_error_message(rescued_error)
        case rescued_error.message
        when /[`']total'/ then "Each element must respond to :total."
        when /[`']map'/ then "Argument must respond to :map."
        end
      end
  end
end
