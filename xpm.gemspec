# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xpm/version'

Gem::Specification.new do |spec|
  spec.name          = "xpm"
  spec.version       = Xpm::VERSION
  spec.authors       = ["msimonin"]
  spec.email         = ["matthieu.simonin@inria.fr"]
  spec.summary       = "xpm is a command line tool to control capi5k"
  spec.description   = "xpm is a command line tool to control capi5k"
  spec.homepage      = "https://capi5k.github.io/capi5k"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency('thor', '~> 0.19')
  spec.add_runtime_dependency('json', '~> 1.8')

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

end
