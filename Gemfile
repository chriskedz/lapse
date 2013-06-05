source 'https://rubygems.org'

# Gem dependencies
puts gemspec

gem 'rake', :group => [:development, :test]

# Development dependencies
group :development do
  gem 'yard'
  gem 'redcarpet', :platform => 'ruby'
end

# Testing dependencies
group :test do
  gem 'minitest'
  gem 'minitest-wscolor' if RUBY_VERSION >= '1.9.3'
  gem 'webmock', :require => 'webmock/minitest'
  gem 'mocha', :require => 'mocha/setup'
  gem 'simplecov', :require => false
  gem 'hashie' #unknown why this is required for certain dev envs to work (ahem, adam)
end
