$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "fake_series"
require 'optparse'
require 'json'
require 'fake_series'
require 'time'

namespace :series do
  namespace :generate do
    task :file do
      opts = parse_options(filename: "-f")
    
      filename = opts[:filename]
      series_spec = JSON.parse(opts[:series])
      series = series_spec.keys[0] if FakeSeries.types.include?(:"#{series_spec.keys[0]}")
      series_args = Hash[series_spec.values[0].map{|k,v| [k.to_sym, v]}]
      time = Time.parse(opts[:time])
      steps = opts[:steps]
      duration = opts[:duration]

      if [filename, series, series_args, steps, time, duration].any?(&:nil?)
        raise OptionParser::MissingArgument, "there is a missing command line argument"
      end

      File.open(filename, "w") do |file|
        FakeSeries.new(steps, time, duration).send(series, **series_args).each do |elt|
          file.puts [elt.time.strftime("%D %H:%M:%S"), elt.value].join("\t")
        end
      end


    end
  end
end

def parse_options(additional_flags = {})
  flags = {
    steps: ["-S", Integer],
    time: "-T",
    duration: ["-D", Numeric],
    # series should be json
    series: "-s"
  }.merge(additional_flags)

  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: rake add [options]"
    
    flags.each do |flag, (short, type)|
      opts.on(short, "--#{flag.to_s}=ARG", type || String) { |val| options[flag] = val}
    end
  end

  parser.parse!(ARGV[2..-1])
  options
end