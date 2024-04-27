module FakeSeries::Generators
  module Composable
    def +(other)
      Expression.new(self, other)
    end
  end
end
