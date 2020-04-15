module FakeSeries::TimeHelpers
  refine Integer do
    def minutes
      self * 60
    end

    def hours
      minutes * 60
    end

    def days
      hours * 24
    end

    def years
      days * 365
    end

    alias minute minutes
    alias hour hours
    alias day days
    alias year years
  end

  refine Time do
    def change(options)
      new_year   = options.fetch(:year, year)
      new_month  = options.fetch(:month, month)
      new_day    = options.fetch(:day, day)
      new_hour   = options.fetch(:hour, hour)
      new_min    = options.fetch(:min, options[:hour] ? 0 : min)
      new_sec    = options.fetch(:sec, (options[:hour] || options[:min]) ? 0 : sec)
      new_offset = options.fetch(:offset, nil)
    
      if new_nsec = options[:nsec]
        raise ArgumentError, "Can't change both :nsec and :usec at the same time: #{options.inspect}" if options[:usec]
        new_usec = Rational(new_nsec, 1000)
      else
        new_usec = options.fetch(:usec, (options[:hour] || options[:min] || options[:sec]) ? 0 : Rational(nsec, 1000))
      end
    
      raise ArgumentError, "argument out of range" if new_usec >= 1000000
    
      new_sec += Rational(new_usec, 1000000)
    
      if new_offset
        ::Time.new(new_year, new_month, new_day, new_hour, new_min, new_sec, new_offset)
      elsif utc?
        ::Time.utc(new_year, new_month, new_day, new_hour, new_min, new_sec)
      elsif zone
        ::Time.local(new_year, new_month, new_day, new_hour, new_min, new_sec)
      else
        ::Time.new(new_year, new_month, new_day, new_hour, new_min, new_sec, utc_offset)
      end
    end
  end
end