require "fake_series/time_helpers"

class FakeSeries
  module Generators
    class PinkNoise
      attr_reader :initial, :time_scales, :max_scale, :amplitude, :offset

      def initialize(initial:, max_scale:, amplitude:, offset: nil)
        @initial = initial
        @time_scales = 1..max_scale
        @max_scale = max_scale
        @amplitude = amplitude
        @offset = offset || SecureRandom.rand(max_scale)
      end

      def hidden_variables(previous)
        if previous
          {last_value: previous.value, step: previous.hidden_variables[:step] + 1}
        else
          {last_value: nil, step: 0}
        end
      end

      def value(elt)
        if elt.hidden_variables[:last_value]
          step_number = elt.hidden_variables[:step]
          elt.hidden_variables[:last_value] + amplitude * random_changes(step_number)
        else
          initial
        end
      end

      def random_changes(step_number)
        time_scales.find_all{ |scale|
            ((step_number + offset) % scale) == 0
          }.sum{ |scale|
            Math.exp(-1.0/scale) * random_change
          }.fdiv(max_scale)
      end

      def random_change
        2 * SecureRandom.rand(2) - 1
      end
    end
  end
end