
module Lapse
  module Transport
    # Default HTTP API transport adapter
    module HTTP
      require 'net/http'
      require 'net/https'
      require 'uri'
      require 'multi_json'
      require 'hashie'

    private

      def http
        return @http if @http

        uri = URI.parse(self.base_url)
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = self.ssl?
        @http
      end

      def request(method, path, params = nil)
        uri = URI.parse("#{self.base_url}#{path}")

        # if the request requires parameters in the query string, merge them in
        if params and !can_post_data?(method)
          query_values = uri.query ? URI.decode_www_form(uri.query).inject({}) {|h,(k,v)| h[k]=v; h} : {}
          uri.query = to_url_params((query_values || {}).merge(params))
        end

        # Build request
        request = build_request(method, uri)

        # Add headers
        request['Authorization'] = "Bearer #{self.access_token}" if authenticated?
        request['X-Seesaw-Client-Token'] = @client_token if @client_token
        request['Content-Type'] = 'application/json'

        # Add params as JSON if they exist
        request.body = MultiJson.dump(params) if can_post_data?(method) and params

        # Request
        response = http.request(request)

        # Check for errors
        handle_error(response)

        # Return the raw response object
        response
      end

      def build_request(method, uri)
        case method
          when :get
            Net::HTTP::Get.new(uri.request_uri)
          when :post
            Net::HTTP::Post.new(uri.request_uri)
          when :put
            Net::HTTP::Put.new(uri.request_uri)
          when :delete
            Net::HTTP::Delete.new(uri.request_uri)
        end
      end

      def to_url_params(hash)
        params = []
        hash.each_pair do |key, value|
          params << param_for(key, value).flatten
        end
        params.sort.join('&')
      end

      def param_for(key, value, parent = nil)
        if value.is_a?(Hash)
          params = []
          value.each_pair do |value_key, value_value|
            value_parent = parent ? parent + "[#{key}]" : key.to_s
            params << param_for(value_key, value_value, value_parent)
          end
          params
        else
          ["#{parent ? parent + "[#{key}]" : key.to_s}=#{CGI::escape(value.to_s)}"]
        end
      end

      def handle_error(response)
        # Find error or return
        return unless error = Lapse::ERROR_MAP[response.code.to_i]

        # Try to add a useful message
        message = nil
        begin
          message = MultiJson.load(response.body)['error_description']
        rescue MultiJson::DecodeError => e
        end

        # Raise error
        raise error.new(message)
      end

      def json_request(*args)
        # Perform request, pass result format
        Response.new(request(*args), result_format)
      end

      def boolean_from_response(*args)
        response = request(*args)
        (200..299).include? response.code.to_i
      end

      def can_post_data?(method)
        [:post, :put].include?(method)
      end

      [:get, :post, :put, :delete].each do |method|
        define_method method do |*args|
          json_request(method, *args)
        end
      end

      # Response class responsible for deserializing API calls
      # @attr [Object] body The parsed response
      # @attr [Hash] headers HTTP headers returned as part of the response
      class Response
        attr_accessor :body, :headers

        # Initializes a new result
        #
        # @param http_response [Net::HTTPResponse] the raw response to parse
        def initialize(http_response, result_format = :mashie)
          @result_format = result_format
          @headers = parse_headers(http_response.to_hash)
          @body = parse_body(http_response.body)
        end

        private

        # Parses raw headers in to a reasonable hash
        def parse_headers(raw_headers)
          # raw headers from net_http have an array for each result. Flatten them out.
          raw_headers.inject({}) do |remainder, (k, v)|
            remainder[k] = [v].flatten.first
            remainder
          end
        end

        # Parses the raw body in to a Hashie::Mash object, an array of Hashie::Mashes, or, if all else fails, returns a hash.
        def parse_body(body)
          # Parse JSON
          object = MultiJson.load(body)

          case @result_format
          when :mashie
            # Hash
            return Hashie::Mash.new(object) if object.is_a? Hash
            # Array
            begin
              return object.map { |h| Hashie::Mash.new(h) } if object.is_a? Array
            rescue
              # sometimes, for things like string arrays, we'll end up with an error. Fall through.
            end
          end

          object
        end
      end

    end
  end
end
