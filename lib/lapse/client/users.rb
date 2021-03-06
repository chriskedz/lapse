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

      def badges(since)
        get('me/badges', since: since).body
      end

      def update_me(options = {})
        params = {
          user: options
        }
        patch('me', params).body
      end

      def user(user_id, params = {})
        get("users/#{user_id}", params).body
      end

      def follow(user_id)
        boolean_from_response(:post, "users/#{user_id}/follow")
      end

      def unfollow(user_id)
        boolean_from_response(:post, "users/#{user_id}/unfollow")
      end

      def following(user_id, params = {})
        get("users/#{user_id}/following", params).body
      end

      def followers(user_id, params = {})
        get("users/#{user_id}/followers", params).body
      end

      def block(user_id)
        boolean_from_response(:post, "users/#{user_id}/block")
      end

      def user(user_id)
        params = {}
        params[:username] = true if user_id.is_a?(String)
        get("users/#{user_id}", params).body
      end
    end
  end
end
