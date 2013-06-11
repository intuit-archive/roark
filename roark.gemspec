# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roark/version'

Gem::Specification.new do |spec|
  spec.name          = "roark"
  spec.version       = Roark::VERSION
  spec.authors       = ["Brett Weaver"]
  spec.email         = ["brett@weav.net"]
  spec.description   = %q{Workflow to build AMIs via Chef and Cloud Formation}
  spec.summary       = %q{Workflow to build AMIs via Chef and Cloud Formation}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "workflow"
end
