require "fake_series/time_helpers"

class FakeSeries
  module Generators
    class Cyclic
      using FakeSeries::TimeHelpers
      attr_reader :period, :amplitude

      def initialize(period:, amplitude:)
        @period = period
        @amplitude = amplitude
      end

      def value(prev, elt)
        amplitude * Math.sin(elt.hidden_variables[:phase])
      end

      def hidden_variables(previous, duration)
        previous_phase = previous.hidden_variables[:phase].to_f

        {
          phase: previous_phase + (2 * Math::PI * (duration.to_f/period))
        }
      end
    end
  end
end