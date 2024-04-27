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

  attr_reader :generator, :time, :steps, :duration, :initial

  GENERATORS = {
    cyclic: Generators::Cyclic,
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
  def initialize(steps, time, duration, initial = 0)
    @steps = steps.to_i
    @time = time
    @duration = duration
    @initial = initial
  end

  # Defines methods for each of the generators
  # to set the generator for iteration
  #
  GENERATORS.each do |name, klass|
    define_method(name) do |**args|
      with_generator(klass.new(**args))
    end
  end

  def with_generator(generator)
    @generator = generator

    self
  end

  def each
    elements = enumerator.take(steps)

    if block_given?
      elements.each { |elt| yield elt }
    else
      elements
    end
  end

  # Maps in batches of size n
  # The block passed will be used in the
  # a map over the elements. The result
  # is an enumerator which yields each batch.
  #
  def in_batches_of(size, &blk)
    size = size.to_i
    batches = (steps / size) + ((steps % size).zero? ? 0 : 1)

    Enumerator.new do |yielder|
      i = 0
      elements = each

      while i < batches
        batch = size.times.inject([]) do |acc, _|
          acc << blk.call(elements.next)
        rescue StopIteration
          break acc
        end

        yielder.yield batch
        i += 1
      end
    end.lazy
  end

  def enumerator
    Enumerator.new do |yielder|
      i = 0
      elt = first_element
      loop do
        yielder << elt

        elt = next_element(elt)
        i += 1
      end
    end.lazy
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
      new(steps, time, duration).random_cyclic(**args).values
    end

    def types
      GENERATORS.keys
    end
  end

  private

  def first_element
    Element.new(
      time, generator, {}, value: initial
    )
  end

  def next_element(last_elt)
    last_elt.next(duration)
  end
end
