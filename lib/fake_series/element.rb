require "fake_series/time_helpers"

class FakeSeries::Element
  using FakeSeries::TimeHelpers

  attr_reader :time, :hidden_variables, :generator, :value

  def initialize(time, generator, hidden_variables, value: nil, previous: nil)
    @time = time
    @generator = generator
    @hidden_variables = hidden_variables
    @value = value || generator.value(previous, self)
  end

  def next(duration)
    hidden_variables = generator.hidden_variables(self, duration)

    self.class.new(
      time + duration,
      generator,
      hidden_variables,
      previous: self
    )
  end
end
