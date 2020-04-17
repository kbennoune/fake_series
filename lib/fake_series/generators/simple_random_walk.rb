require "fake_series/time_helpers"

module FakeSeries::Generators
  class SimpleRandomWalk
    attr_reader :initial, :step_size

    def initialize(initial:, step_size:)
      @initial = initial
      @step_size = step_size
    end

    def value(elt)
      if elt.hidden_variables[:last_value]
        elt.hidden_variables[:last_value] + step_size * random_change
      else
        initial
      end
    end

    def random_change
      2 * SecureRandom.rand(2) - 1
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