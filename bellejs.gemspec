# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bellejs/version'

Gem::Specification.new do |spec|
  spec.name          = "bellejs"
  spec.version       = Bellejs::VERSION
  spec.authors       = ["Ryan Epp"]
  spec.email         = ["repp@redtettemer.com"]
  spec.description   = %q{Better Object Oriented Javascript Transpiler}
  spec.summary       = %q{This gem takes bellejs formatted code and transpiles it into valid mimified javascript.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
