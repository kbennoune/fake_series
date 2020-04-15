require_relative 'lib/fake_series/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_series"
  spec.version       = FakeSeries::VERSION
  spec.authors       = ["kbennoune"]
  spec.email         = ["kbennoune@gmail.com"]

  spec.summary       = %q{Realistic looking time series data}
  spec.description   = %q{Realistic looking time series data}
  spec.homepage      = "https://github.com/kbennoune/fake_series"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kbennoune/fake_series"
  spec.metadata["changelog_uri"] = "https://github.com/kbennoune/fake_series/Readme.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug"
end
