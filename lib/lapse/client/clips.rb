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

      def create_clip(title = nil)
        params = {
          :title => title
        }
        post('clips', params).body
      end

      def accept_frames(clip_id, frame_ids)
        params = {
          :frame_ids => frame_ids
        }
        post("clips/#{clip_id}/accept_frames", params).body
      end

      def publish_clip(clip_id)
        post("clips/#{clip_id}/publish").body
      end

      def destroy_clip(clip_id)
        boolean_from_response(:delete, "clips/#{clip_id}")
      end
    end
  end
end
