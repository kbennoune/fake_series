require "fake_series/time_helpers"

module FakeSeries::Generators
  class GaussianRandomWalk
    using FakeSeries::TimeHelpers
    attr_reader :initial, :std_deviation

    def initialize(initial:, std_deviation:)
      @initial = initial.to_f
      @std_deviation = std_deviation.to_f
    end

    def value(elt)
      if elt.hidden_variables[:last_value]
        elt.hidden_variables[:last_value] + std_deviation * random_change
      else
        initial
      end
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

    def hidden_variables(previous)
      if previous
        {last_value: previous.value}
      else
        {last_value: nil}
      end
    end
  end
end