module Lapse
  class Client
    module UserTimelines
      def user_timeline(user_id, params = {})
        get("users/#{user_id}/timelines/user", params).body
      end

      def user_likes_timeline(user_id, params = {})
        get("users/#{user_id}/timelines/liked", params).body
      end

      def user_contributed_timeline(user_id, params = {})
        get("users/#{user_id}/timelines/contributed", params).body
      end

      def user_contributors_timeline(user_id, params = {})
        get("users/#{user_id}/timelines/contributors", params).body
      end
    end
  end
end
