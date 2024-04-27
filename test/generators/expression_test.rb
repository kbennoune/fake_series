require "test_helper"

module Generators
  class ExpressionTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_summed_series
      time = Time.now
      series = FakeSeries.new(1 * 24 * 60, time, 1.minute)

      generator = FakeSeries::Generators::PinkNoise.new(
        max_scale: 25,
        amplitude: 1
      ) +
                  FakeSeries::Generators::Cyclic.new(
                    period: 1.day,
                    amplitude: 20
                  )
      data = series.with_generator(generator).to_a
      sum_of_differences = data.each_with_index.sum do |elt, i|
        if i.zero?
          0
        else
          theta1 = 2 * Math::PI * ((data[i - 1].time - time).to_f / 24.hours)
          theta2 = 2 * Math::PI * ((elt.time - time).to_f / 24.hours)
          periodic_difference = 2 * (Math.sin(theta2) - Math.sin(theta1))

          (elt.value.to_f - data[i - 1].value.to_f - periodic_difference) ** 2
        end
      end
      sigma = Math.sqrt(sum_of_differences / (data.length - 1))
      # Need to derive this
      expected_sigma = 0.085
      assert_in_delta(sigma, expected_sigma, 0.01)
    end
  end
end
