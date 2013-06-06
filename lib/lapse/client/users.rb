module Lapse
  class Client
    # Client methods for working with users
    module Users
      # Authenticates a user
      #
      # Requires authenticatied client.
      #
      # @return [Hashie::Mash]
      # @see Lapse::Client
      # @example
      #   client.me
      def authenticate(twitter_access_token)
        result = post('authenticate', twitter_access_token: twitter_access_token)
        hash = {
          :user => result.body,
          :access_token => result.headers['x-access-token']
        }

        case @result_format
        when :mashie
          Hashie::Mash.new(hash)
        else
          hash
        end
      end

      # Get the current user
      #
      # Requires authenticatied client.
      #
      # @return [Hashie::Mash]
      # @see Totter::Client
      # @example
      #   client.me
      def me
        get('me').body
      end
    end
  end
end