# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/one/version'

Gem::Specification.new do |spec|
  spec.name          = 'resque-one'
  spec.version       = Resque::One::VERSION
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']

  spec.summary       = 'Resque plugin to specify uniq jobs with the same payload per queue'
  spec.description   = 'Resque plugin to specify uniq jobs with the same payload per queue'
  spec.homepage      = 'https://github.com/gabynaiman/resque-one'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'resque', '~> 1.25'
  spec.add_runtime_dependency 'consty', '~> 1.0'
  spec.add_runtime_dependency 'class_config', '~> 0.0'

  spec.add_development_dependency 'resque-status', '~> 0.5'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'minitest', '~> 5.0', '< 5.11'
  spec.add_development_dependency 'minitest-colorin', '~> 0.1'
  spec.add_development_dependency 'minitest-line', '~> 0.6'
  spec.add_development_dependency 'simplecov', '~> 0.14'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
end
