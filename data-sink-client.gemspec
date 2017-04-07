# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data-sink-client/version'

Gem::Specification.new do |spec|
  spec.name          = "data-sink-client"
  spec.description   = "Client for data-sink"
  spec.version       = DataSinkClient::VERSION
  spec.authors       = ["Ivan Pirlik"]
  spec.email         = ["ivan.pirlik@deliveroo.co.uk"]

  spec.summary       = %q{Client for the data-sink service}
  spec.homepage      = "https://github.com/deliveroo/data-sink-client"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(bin|test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '> 0.10.0'
  spec.add_dependency 'excon', '~> 0.55.0'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
end
