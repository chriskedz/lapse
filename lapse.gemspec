# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lapse/version'

Gem::Specification.new do |gem|
  gem.name          = 'lapse'
  gem.version       = Lapse::VERSION
  gem.authors       = ['Sam Soffes', 'Aaron Gotwalt', 'Adam Ryan']
  gem.email         = ['sam@soff.es', 'gotwalt@gmail.com', 'adam.g.ryan@gmail.com']
  gem.description   = 'Ruby gem for working with the Everlapse API.'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/seesawco/lapse-rb'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.8.7'
  gem.add_dependency 'multi_json', '~> 1.6'
  gem.add_dependency 'hashie', '~> 1.2.0'
end
