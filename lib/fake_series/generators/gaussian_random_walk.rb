require "fake_series/time_helpers"

module FakeSeries::Generators
  class GaussianRandomWalk
    include FakeSeries::Generators::Composable
    using FakeSeries::TimeHelpers

    attr_reader :std_deviation

    def initialize(std_deviation:)
      @std_deviation = std_deviation.to_f
    end

    def value(prev, _elt)
      prev.value + std_deviation * random_change
    end

    def random_change
      # 2 * SecureRandom.rand(2) - 1
      random_normal
    end

    def random_normal
      sum_squares = 0

      while sum_squares > 1 || sum_squares == 0
        x = SecureRandom.rand(2.0) - 1.0
        y = SecureRandom.rand(2.0) - 1.0
        sum_squares = (x ** 2) + (y ** 2)
      end

      x * Math.sqrt(-2 * Math.log(sum_squares) / sum_squares)
    end

    def hidden_variables(_previous, _duration)
      {}
    end
  end
end
