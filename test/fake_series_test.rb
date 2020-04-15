require "test_helper"

class FakeSeriesTest < Minitest::Test
  using FakeSeries::TimeHelpers

  def test_it_iterates_a_value
    configuration = FakeSeries::Generators::RandomCyclic.new(
      frequency: 0.177,
      amplitude: 2,
      min: 18.0,
      max: 25.0
    )

    previous_val = FakeSeries.new(
      Time.now - 1.year,
      {phase: 0},
      configuration
    )
    val = FakeSeries.from(previous_val, 1.minute)

    val.value 

    assert val.time == previous_val.time + 1.minute
    assert_in_delta(21.5, val.value, 5.5)
  end

  def test_creates_a_time_series_for_a_day
    array = FakeSeries.array(24 * 60, Time.now - 1.year, 1.minute, 0.177, 2, 18.0, 25.0)
    assert array.length == (24 * 60)
  end

  def test_creates_a_time_series_for_a_year
    array = FakeSeries.array(365 * 3, Time.now - 1.year, 8.hours, 0.177, 2, 18.0, 25.0)
    assert array.length == (365 * 3)
  end

  def test_creates_a_large_series
    array = FakeSeries.array(24 * 60 * 3, Time.now - 1.year, 1.minute, 0.077, 2, 18.0, 25.0)

    (array.length - 1).times.each do |i| 
      assert_in_delta(2, array[i], array[i + 1])
    end
  end
end
