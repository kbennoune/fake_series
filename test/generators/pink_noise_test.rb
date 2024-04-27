require "test_helper"

module Generators
  class PinkNoiseTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_pink_noise_series
      series = FakeSeries.new(1 * 24 * 60, Time.now, 1.minute)
                         .pink_noise(max_scale: 15, amplitude: 1)

      data = series.to_a

      sum_of_differences = data.each_with_index.sum do |elt, i|
        i.zero? ? 0 : (elt.value - data[i - 1].value) ** 2
      end
      sigma = Math.sqrt(sum_of_differences / (data.length - 1))
      # Need to derive this
      expected_sigma = 0.085
      assert_in_delta(sigma, expected_sigma, 0.01)
    end
  end
end
