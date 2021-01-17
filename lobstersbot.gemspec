lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lobstersbot/version"

Gem::Specification.new do |spec|
  spec.name          = "lobstersbot"
  spec.version       = Lobstersbot::VERSION
  spec.authors       = ["Hunter Madison"]
  spec.email         = ["hmadison@users.noreply.github.com"]

  spec.summary       = %q{Lobste.rs IRC bot}
  spec.homepage      = "https://github.com/lobsters/lobstersbot"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  
  spec.add_runtime_dependency 'summer', '~> 1.0'
  spec.add_runtime_dependency 'timers', '~> 4.1'
  spec.add_runtime_dependency 'rss', '~> 0.2.9'
end
