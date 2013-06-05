require 'rubygems'
require 'bundler'
Bundler.require :test

require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end

require 'minitest/autorun'
require 'Lapse'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

class Lapse::TestCase < MiniTest::Unit::TestCase
  include ::ClientMacros
end
