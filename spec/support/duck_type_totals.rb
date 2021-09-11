# frozen_string_literal: true

module DuckTypeTotals
  class Group
    include Enumerable

    def each(&block)
      @ducks.each(&block)
    end

    private

      def initialize(kind_of_duck)
        @ducks = kind_of_duck == "good" ? good_ducks : bad_ducks
      end

      def good_ducks
        [GoodDuck.new, GoodDuck.new]
      end

      def bad_ducks
        [BadDuck.new, BadDuck.new]
      end
  end

  class GoodDuck
    def total
      5
    end
  end

  class BadDuck
    # rubocop:disable Style/RedundantSelf
    def total
      self.foo
    end
    # rubocop:enable Style/RedundantSelf
  end
end
