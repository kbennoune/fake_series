require "fake_series/version"
require "fake_series/generators"
require "fake_series/time_helpers"
require "securerandom"
require "forwardable"

# frozen_string_literal: true

# Method of creating realisticish time series values
# If adds a random osciallating value to a base daily
# change.
#
# Best to access it throught the array class method.
#
class FakeSeries
  using TimeHelpers
  extend Forwardable

  attr_reader :time, :hidden_variables, :generator
  
  # frequency should be less than 2
  def initialize(time, previous_hidden_variables, generator)
    @time = time
    @generator = generator
    @hidden_variables = generator.hidden_variables(previous_hidden_variables)
  end

  def value
    generator.value(self)
  end

  class << self
    # Creates a new time value from an earlier time value
    # Most of the attribute are read from the passed
    # object.
    # The time step is applied when generating the next value
    #
    def from(element, step)
      self.new(
        element.time + step,
        element.hidden_variables,
        element.generator
      )
    end

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
    def array(n, time, step, *args)
      generator = Generators::RandomCyclic.from_args(*args)
      prev = self.new(
        time, {}, generator
      )
      i = 0
      acc = []
      while i < n
        prev = from(prev, step)
        acc << prev.value
        i += 1
      end

      acc
    end
  end


end
