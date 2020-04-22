require "fake_series/time_helpers"

class FakeSeries
  module Generators
    class PinkNoise
      include FakeSeries::Generators::Composable

      attr_reader :time_scales, :max_scale, :amplitude, :offset

      def initialize(max_scale:, amplitude:, offset: nil)
        @time_scales = 1..max_scale
        @max_scale = max_scale
        @amplitude = amplitude
        @offset = offset || SecureRandom.rand(max_scale)
      end

      def hidden_variables(previous, _duration)
        {step: previous.hidden_variables[:step].to_i + 1}
      end

      def value(prev, elt)
        step_number = elt.hidden_variables[:step]
        prev.value + amplitude * random_changes(step_number)
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