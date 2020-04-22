# FakeSeries

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fake_series`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fake_series'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fake_series

## Usage

### Simple Series
number_of_steps = (1.year / 1.minute)
start_date = (Time.now - number_of_steps.minutes)
step_length = 1.minute
initial = 0

series = FakeSeries.new(number_of_steps, start_date, step_length, initial)

series.simple_random_walk(amplitude: 10).each do |step|
  puts [step.time.strftime("%D %H:%M:%S"), step.value].join("\t")
end

The following generators are available
* cyclic
    amplitude: Numeric
    period: Numeric (number of seconds to complete the cycle)
* random_cyclic 
    frequency: Numeric
    amplitude: Numeric
    min: Numeric
    max: Numeric
    peakhour: Numeric(0..23)
* simple_random_walk
    amplitude: Numeric
* gaussian_random_walk
    std_deviation: Numeric
* pink_noise
    max_scale: Integer (lowest subfrequency added)
    amplitude: Numeric
    offset: Integer (Which subfrequency one is on)


### Expressions
You can create a series that's the sum of two other series

number_of_steps = (1.week / 1.minute)
start_date = (Time.now - number_of_steps.minutes)
step_length = 1.minute
initial = 0

series = FakeSeries.new(number_of_steps, start_date, step_length, initial)

generator = FakeSeries::Generators::PinkNoise.new(
            max_scale: 25,
            amplitude: 1
            ) +
            FakeSeries::Generators::Cyclic.new(
            period: 1.day,
            amplitude: 20
            )


series.with_generator(generator).each do |step|
  puts [step.time.strftime("%D %H:%M:%S"), step.value].join("\t")
end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fake_series. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fake_series/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FakeSeries project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fake_series/blob/master/CODE_OF_CONDUCT.md).
