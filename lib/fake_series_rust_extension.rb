require 'rutie'

module FakeSeriesRustExtension
  class << self
    attr_accessor :disabled

    def enabled?
      !disabled
    end

    def warn_rust_disabled(e)
      message = ["Rust extensions disabled..."]
      if $DEBUG
        message << e.full_message
      end
  
      message << "Try building the rust extension with cargo build --release"
  
      Warning.warn(message.join("\n") + "\n")
    end
  end

  begin
    Rutie.new(:fake_series_rust_extension).init 'Init_fake_series_rust_extension', __dir__
  rescue Exception => e
    warn_rust_disabled(e)

    self.disabled = true
  end

end