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

      def clip(clip_id, slug = false)
        params = {}
        params[:slug] = true if slug
        get("clips/#{clip_id}", params).body
      end

      def create_clip
        post('clips').body
      end

      def update_clip(clip_id, options)
        params = { clip: options }
        patch("clips/#{clip_id}", params).body
      end

      def submit_frames(clip_id, frame_ids)
        params = {
          :frame_ids => frame_ids
        }
        post("clips/#{clip_id}/submit_frames", params).body
      end

      def publish_clip(clip_id, title = nil)
        params = {
          :clip => {
            :title => title
          }
        }
        post("clips/#{clip_id}/publish", params).body
      end

      def flag_clip(clip_id)
        boolean_from_response(:post, "clips/#{clip_id}/flag")
      end

      def unflag_clip(clip_id)
        post("clips/#{clip_id}/unflag").body
      end

      def destroy_clip(clip_id)
        boolean_from_response(:delete, "clips/#{clip_id}")
      end
    end
  end
end
