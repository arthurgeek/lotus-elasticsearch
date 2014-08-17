# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lotus/elasticsearch/version"

Gem::Specification.new do |spec|
  spec.name          = "lotus-elasticsearch"
  spec.version       = Lotus::Elasticsearch::VERSION
  spec.authors       = ["Arthur Zapparoli"]
  spec.email         = ["arthurzap@gmail.com"]
  spec.summary       = spec.description = %q{ElasticSearch adapter for Lotus::Model}
  spec.homepage      = "http://www.github.com/arthurgeek/lotus-elasticsearch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z -- lib/* CHANGELOG.md LICENSE.md README.md lotus-elasticsearch.gemspec`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "lotus-model", "~> 0.1"
  spec.add_dependency "elasticsearch", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "elasticsearch-extensions"
  spec.add_development_dependency "minitest", "~> 4.0"
  spec.add_development_dependency "turn"
  spec.add_development_dependency "simplecov"
end
