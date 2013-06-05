require 'Lapse/version'
require 'Lapse/client'
require 'Lapse/error'

# Lapse, as in teeter-Lapse, let's you work with the Seesaw API in Ruby.
module Lapse
  class << self
    # Alias for Lapse::Client.new
    #
    # @return [Lapse::Client]
    def new(options = {})
      Client.new(options)
    end

    # Delegate to Lapse::Client.new
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    # Forward respond_to? to Lapse::Client.new
    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
