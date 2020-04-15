require "test_helper"

module Generators
  class RandomCyclicTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_creates_a_time_series_for_a_day
      last_year = Time.now - 1.year
      series = FakeSeries.new(24 * 60, last_year, 1.minute)
      series.random_cyclic(frequency: 0.177, amplitude: 2, min: 18.0, max: 25.0)
      times = series.map(&:time)
      assert times[0].to_i == last_year.to_i
    end

    def test_each_member_of_series_has_limited_variation
      time = Time.now
      series = FakeSeries.new(24 * 60, Time.now, 1.minute).random_cyclic(frequency: 1, amplitude: 2, min: 3, max: 4)
      elts = []

      series.each do |elt|
        elts << elt.time
      end

      assert elts[0].to_i == time.to_i
      assert elts[-1].to_i == (time + 1.day - 1.minute).to_i
    end
  end
end