module FakeSeries::Generators
  module Composable

    def +(composable)
      Expression.new(self, composable)
    end
  end
end