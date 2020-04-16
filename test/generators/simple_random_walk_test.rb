require 'test_helper'

module Generators
  class SimpleRandomWalkTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_fake_series_defines_simple_random_walk
      series = FakeSeries.new(60, Time.now, 1.minute)

      assert series.respond_to?(:simple_random_walk)
      assert series.methods.include?(:simple_random_walk)
    end 

    def test_a_simple_random_walk
      last_year = Time.now - 1.day

      series = FakeSeries.new(4 * 24 * 60, last_year, 1.minute)

      data = series.simple_random_walk(initial: 10, step_size: 1).to_a

      data.each_with_index do |elt, i|
        if i == 0
          assert elt.value == 10
        else
          step_difference = data[i-1].value - elt.value
          assert step_difference.abs == 1
        end
      end
    end
  end
end