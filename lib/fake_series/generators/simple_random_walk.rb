require "fake_series/time_helpers"

module FakeSeries::Generators
  class SimpleRandomWalk
    include FakeSeries::Generators::Composable

    attr_reader :amplitude

    def initialize(amplitude:)
      @amplitude = amplitude
    end

    def value(prev, elt)
      prev.value + amplitude * random_change
    end

    def random_change
      2 * SecureRandom.rand(2) - 1
    end

    def hidden_variables(previous, _duration)
      {}
    end
  end
end