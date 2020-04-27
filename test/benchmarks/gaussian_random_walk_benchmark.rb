require 'test_helper'

module Generators
  class GaussianRandomWalkTest < Minitest::Benchmark
    def self.bench_range
      bench_exp(10, 10_000)
    end

    def bench_generate_series
      assert_performance_bt(1e-8) do
        generator = FakeSeries::Generators::GaussianRandomWalk.new(std_deviation: 1.0)

        1000.times {
          generator.random_change
        }
      end
    end

    def assert_performance_bt(secs, &blk)
      assert_performance_constant(1 - secs, &blk)
    end
  end
end