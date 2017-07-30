# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alki/loader/version'

Gem::Specification.new do |spec|
  spec.name          = "alki-loader"
  spec.version       = Alki::Loader::VERSION
  spec.authors       = ["Matt Edlefsen"]
  spec.email         = ["matt.edlefsen@gmail.com"]

  spec.summary       = %q{Library for loading non-traditional ruby files}
  spec.homepage      = "https://github.com/alki-project/alki-loader"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "alki-support", "~> 0.7"
end
