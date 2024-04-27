require "fake_series/time_helpers"

class FakeSeries
  module Generators
    class RandomCyclic
      include FakeSeries::Generators::Composable
      using FakeSeries::TimeHelpers

      def initialize(frequency:, amplitude:, min:, max:, peakhour: 3)
        @frequency = frequency
        @amplitude = amplitude
        @min = min
        @max = max
        @peakhour = peakhour
      end

      def value(_prev, elt)
        current_phase = elt.hidden_variables[:phase]
        time = elt.time
        (base_value(time) + random_variation(current_phase))
      end

      def hidden_variables(previous, _duration)
        {
          phase: next_phase(previous.hidden_variables[:phase] || 0)
        }
      end

      private

      attr_reader :frequency, :amplitude, :min, :max, :peakhour
      alias minvalue min
      alias maxvalue max

      def random_variation(current_phase)
        amplitude * Math.cos(current_phase)
      end

      def next_phase(previous_phase)
        random_phase = SecureRandom.rand(2 * frequency)
        (previous_phase + random_phase) % 2.0
      end

      def base_value(time)
        maxvalue - (value_slope * difference(time))
      end

      # At the moment all of the values peak at 5pm
      # and are lowest at 5am.
      def peaktime(time)
        if peakhour > 12 && time.hour < (peakhour - 12)
          time.change(hour: peakhour) - 1.day
        elsif peakhour <= 12 && time.hour > (peakhour + 12)
          time.change(hour: peakhour) + 1.day
        else
          time.change(hour: peakhour)
        end
      end

      def difference(time)
        (time - peaktime(time)).abs
      end

      def value_slope
        (maxvalue - minvalue) / (12.0 * 60.0 * 60.0)
      end
    end
  end
end
