require "fake_series/version"
require "fake_series/element"
require "fake_series/generators"
require "fake_series/time_helpers"
require "securerandom"
require "forwardable"

# Allows the creation of random series using different
# algorithims. 
#
class FakeSeries
  include Enumerable

  attr_reader :generator, :time, :steps, :duration

  GENERATORS = {
    random_cyclic: Generators::RandomCyclic,
    simple_random_walk: Generators::SimpleRandomWalk,
    gaussian_random_walk: Generators::GaussianRandomWalk,
    pink_noise: Generators::PinkNoise
  }

  # Initializes the series
  # 
  # steps - The number of steps in the series
  # time - The beginning time
  # duration - The time length of each step
  # *args - args to be passed to the generator
  #
  def initialize(steps, time, duration)
    @steps = steps
    @time = time
    @duration = duration
  end

  # Defines methods for each of the generators
  # to set the generator for iteration
  #
  GENERATORS.each do |name, klass|
    define_method(name) do |**args|
      @generator = klass.new(**args)

      self
    end
  end

  def each
    i = 0

    while i < steps
      elt = next_element(elt, i)
      yield elt
      i += 1
    end
  end

  def values
    map(&:value)
  end

  class << self
    # Easiest interface to use
    # You can generate a list of n values e.g.
    # FakeSeries.array(
    #   3 * 100,
    #   initial_time,
    #   0.03,
    #   20.0,
    #   45.0,
    #   25.0,
    #   100
    # )
    # will create 300 values over 100 days. The base values will
    # be between 25 and 45 with an additional random osciallation
    # of 20.
    def array(steps, time, duration, **args)
      self.new(steps, time, duration).random_cyclic(**args).values
    end

    def types
      GENERATORS.keys
    end
  end

  private

  def next_element(last_elt, step)
    if step == 0
      Element.new(
        time, nil, generator
      )
    else
      last_elt.next(duration)
    end
  end
end
