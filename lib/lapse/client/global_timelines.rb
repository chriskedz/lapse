module Lapse
  class Client
    module GlobalTimelines
      def global_timeline(params = {})
        get("timelines/global", params).body
      end

      def featured_timeline(params = {})
        get("timelines/featured", params).body
      end
    end
  end
end
