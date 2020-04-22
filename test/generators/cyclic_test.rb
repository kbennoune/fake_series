require "test_helper"

module Generators
  class CyclicTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_method_is_defined_on_fake_series
      series = FakeSeries.new(1, Time.new, 1.minute)

      assert series.respond_to?(:cyclic)
      assert series.methods.include?(:cyclic)
    end

    def test_creates_a_time_series_for_a_day
      last_year = Time.now - 1.year
      series = FakeSeries.new(24 * 60, last_year, 1.minute)
      series.cyclic(period: 1.day, amplitude: 1)
      times = series.map(&:time)
      assert times[0].to_i == last_year.to_i
    end

    def test_series_varies_sinusoidaly
      time = Time.now
      series = FakeSeries.new(24 * 60, Time.now, 1.minute).cyclic(
        period: 1.day, 
        amplitude: 2
      )

      series.each do |elt|
        theta = 2 * Math::PI * ((elt.time - time).to_f / 24.hours)
        assert_in_delta elt.value, 2 * Math.sin(theta), 1e-6
      end
    end
  end
end