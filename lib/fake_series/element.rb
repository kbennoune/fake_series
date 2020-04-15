require "fake_series/time_helpers"
require "securerandom"

class FakeSeries::Element
  using FakeSeries::TimeHelpers

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
  end
end