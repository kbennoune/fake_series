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

number_of_steps = (1.year / 1.minute)
start_date = (Time.now - number_of_steps.minutes)
step_length = 1.minute

series = FakeSeries.new(number_of_steps, start_date, step_length)

series.simple_random_walk(initial: 0, amplitude: 10).each do |step|
  puts [step.time.strftime("%D %H:%M:%S"), step.value].join("\t")
end

The following generators are available
* random_cyclic 
    frequency: Numeric 
    amplitude: Numeric
    min: Numeric
    max: Numeric
    peakhour: Numeric(0..23)
    initial: Numeric
* simple_random_walk
    initial: Numeric
    amplitude: Numeric
* gaussian_random_walk
    initial: Numeric
    std_deviation: Numeric
*pink_noise
    initial: Numeric
    max_scale: Integer (lowest subfrequency added)
    amplitude: Numeric
    offset: Integer (Which subfrequency one is on)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fake_series. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fake_series/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FakeSeries project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fake_series/blob/master/CODE_OF_CONDUCT.md).
