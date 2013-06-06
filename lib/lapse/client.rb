require 'Lapse/transport'
require 'uri'

module Lapse
  # API client for interacting with the Seesaw API
  class Client
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Clips
    include Configuration
    include Frames
    include Users

    attr_reader :access_token
    attr_reader :api_scheme
    attr_reader :api_host
    attr_reader :api_prefix
    attr_reader :api_version
    attr_reader :transport
    attr_reader :result_format

    # Default parameters for the client
    DEFAULTS = {
      :api_scheme => 'https',
      :api_host => 'everlapse.com',
      :api_version => '1',
      :api_prefix => 'api',
      :result_format => :mashie,
      :transport => :http
    }

    # The current configuration parameters for all clients
    def self.options
      @options ||= Hashie::Mash.new(DEFAULTS.dup)
    end

    # Sets the current configuration parameters for all clients
    def self.options=(val)
      @options = val
    end

    # Allows the setting of configuration parameters in a configure block.
    def self.configure
      yield options
    end

    # Initialize a new client.
    #
    # @param options [Hash] optionally specify `:access_token`, `:api_scheme`, `:api_host`, ':api_url', `:api_version`, `:client_token`, or `:transport`.
    def initialize(options = {})
      options = { :access_token => options } if options.is_a? String
      options = self.class.options.merge(options)

      # Parse `api_url` option
      if url = options.delete(:api_url)
        uri = URI.parse(url)
        options[:api_scheme] = uri.scheme
        options[:api_host] = uri.host + (uri.port != 80 && uri.port != 443 ? ":#{uri.port}" : '')
      end

      @access_token = options[:access_token] if options[:access_token]
      @api_scheme = options[:api_scheme]
      @api_host = options[:api_host]
      @api_version = options[:api_version]
      @api_prefix = options[:api_prefix]
      @client_token = options[:client_token] if options[:client_token]
      @transport = options[:transport]
      @result_format = options[:result_format]

      # Include transport
      transport_module = Lapse::Transport::TRANSPORT_MAP[@transport]
      raise 'Invalid transport' unless transport_module
      self.extend transport_module
    end

    # API base URL.
    #
    # @return [String] API base URL
    def base_url
      "#{@api_scheme}://#{@api_host}/#{@api_prefix}/v#{@api_version}/"
    end

    # Is the client has an access token.
    #
    # @return [Boolean] true if it is using one and false if it is not
    def authenticated?
      @access_token != nil and @access_token.length > 0
    end

    # Is the client using SSL.
    #
    # @return [Boolean] true if it is using SSL and false if it is not
    def ssl?
      @api_scheme == 'https'
    end

    # Returns the current status of HTTP stubbing
    def self.stubbed?
      @@stubbed
    end
  end
end
