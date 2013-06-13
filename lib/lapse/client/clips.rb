module Lapse
  class Client
    # Client methods for working with clips
    module Clips
      def all_clips
        get('clips').body
      end

      def featured_clips
        get('clips/featured').body
      end

      def clip(clip_id)
        get("clips/#{clip_id}").body
      end

      def create_clip
        post('clips').body
      end

      def accept_frames(clip_id, frame_ids)
        params = {
          :frame_ids => frame_ids
        }
        post("clips/#{clip_id}/accept_frames", params).body
      end

      def publish_clip(clip_id, title)
        params = {
          :clip => {
            :title => title
          }
        }
        post("clips/#{clip_id}/publish", params).body
      end

      def destroy_clip(clip_id)
        boolean_from_response(:delete, "clips/#{clip_id}")
      end
    end
  end
end
