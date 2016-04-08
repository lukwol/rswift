# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rswift/version'

Gem::Specification.new do |spec|
  spec.name          = 'rswift'
  spec.version       = RSwift::VERSION
  spec.authors       = ['Lukasz Wolanczyk']
  spec.email         = ['wolanczyk.lukasz@gmail.com']

  spec.summary       = 'RSwift allows to create and develop iOS, OSX, tvOS and watchOS projects using CLI.'
  spec.homepage      = 'https://github.com/lukwol/rswift'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['rswift']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_runtime_dependency 'xcodeproj'
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'thor'
end
