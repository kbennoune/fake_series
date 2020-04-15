require "fake_series/time_helpers"
require "securerandom"

class FakeSeries::Element
  using FakeSeries::TimeHelpers

  attr_reader :time, :hidden_variables, :generator
  
  # frequency should be less than 2
  def initialize(time, previous, generator)
    @time = time
    @generator = generator
    @hidden_variables = generator.hidden_variables(previous)
  end

  def value
    @value ||= generator.value(self)
  end

  def next(duration)
    self.class.new(
      self.time + duration,
      self,
      self.generator
    )
  end
end