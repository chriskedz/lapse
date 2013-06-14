module Lapse
  class Client
    # Client methods for working with clips
    module Frames
      def clip_frames(clip_id)
        get("clips/#{clip_id}/frames").body
      end

      def create_frame(clip_id)
        post("clips/#{clip_id}/frames").body
      end

      def destroy_frame(clip_id, frame_id)
        boolean_from_response(:delete, "clips/#{clip_id}/frames/#{frame_id}")
      end

      def crop_frame(clip_id, frame_id, x, y, width, height)
        params = {
          x: x,
          y: y,
          width: width,
          height: height
        }
        boolean_from_response(:post, "clips/#{clip_id}/frames/#{frame_id}/crop", params)
      end

    end
  end
end
