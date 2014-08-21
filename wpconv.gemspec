# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wpconv/version'

Gem::Specification.new do |spec|
  spec.name          = "wpconv"
  spec.version       = Wpconv::VERSION
  spec.authors       = ["akahige"]
  spec.email         = ["akahigeg@gmail.com"]
  spec.summary       = %q{Converting Wordpress export XML to other format.}
  spec.description   = %q{Converting Wordpress export XML to other format.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
