require "test_helper"

module Generators
  class GaussianRandomWalkTest < Minitest::Test
    using FakeSeries::TimeHelpers

    def test_random_gaussian_distribution
      generator = FakeSeries::Generators::GaussianRandomWalk.new(initial: 0, std_deviation: 1)

      data = 1000.times.map{
        generator.random_normal
      }
      avg = (data.sum / data.length)
      variance = data.sum{ |x| (x - avg)**2 } / data.length
      sigma = Math.sqrt(variance)
      assert_in_delta(avg, 0, 0.1)
      assert_in_delta(sigma, 1, 0.1)
    end

    def test_a_gaussian_random_walk
      last_year = Time.now - 1.day

      series = FakeSeries.new(4 * 24 * 60, last_year, 1.minute)

      data = series.gaussian_random_walk(initial: 10, std_deviation: 10).to_a

      sum_of_differences = data.each_with_index.sum do |elt, i|
        i.zero? ? 0 : (elt.value - data[i-1].value) ** 2
      end

      sigma = Math.sqrt(sum_of_differences / (data.length - 1))
      assert_in_delta(sigma, 10, 0.2)
    end
  end
end