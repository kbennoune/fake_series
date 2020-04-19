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

    previous_val = FakeSeries::Element.new(
      Time.now - 1.year,
      nil,
      configuration
    )
    val = previous_val.next(1.minute)

    val.value 

    assert val.time == previous_val.time + 1.minute
    assert_in_delta(21.5, val.value, 5.5)
  end

  def test_creates_a_time_series_array_for_a_day
    array = FakeSeries.array(24 * 60, Time.now - 1.year, 1.minute, frequency: 0.177, amplitude: 2, min: 18.0, max: 25.0)
    assert array.length == (24 * 60)
  end

  def test_creates_a_time_series_for_a_year
    array = FakeSeries.array(365 * 3, Time.now - 1.year, 8.hours, frequency: 0.177, amplitude: 2, min: 18.0, max: 25.0)
    assert array.length == (365 * 3)
  end
  
  def test_creates_a_large_series
    array = FakeSeries.array(24 * 60 * 3, Time.now - 1.year, 1.minute, frequency: 0.077, amplitude: 2, min: 18.0, max: 25.0)

    (array.length - 1).times.each do |i| 
      assert_in_delta(2, array[i], array[i + 1])
    end
  end

  def test_in_batches
    batches = []
    batch_iterators = []
    i = 0
    now = Time.now
    series = FakeSeries.new(250, now, 1.minute)
    data_builder = series.simple_random_walk(initial: 10, amplitude: 1)
    data_builder.in_batches_of(120) do |elt|
      i += 1
      { time: elt.time, value: elt.value, i: i }
    end.each do |batch|
      batch_iterators << i
      batches << batch
    end

    assert batches.size == 3
    assert batches[0].size == 120
    assert batches[1].size == 120
    assert batches[2].size == 10

    assert batch_iterators[0] == 120
    assert batch_iterators[1] == 240
    assert batch_iterators[2] == 250

    assert batches[0][0][:time] == now
    assert batches[0][0][:value] == 10
    assert_in_delta(batches[2][9][:time].to_i, (now + 249.minutes).to_i, 1)
  end
end
