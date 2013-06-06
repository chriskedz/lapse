require 'thor'
require 'faraday'
require 'faraday_middleware'

module Lapse
  class Cli < Thor
    desc 'signin', 'Signs the user in by passing in a twitter token'
    def signin(token)
      result = unauthenticated_client.authenticate(token)
      self.access_token = result['access_token']
      puts "Signed in as #{result.user.username}"
    end

    desc 'signout', 'Signs the user out'
    def signout
      self.access_token = nil
      puts 'Signed out'
    end

    desc 'create_clip', 'Creates a clip'
    def create_clip(title, *images)
      clip = authenticated_client.create_clip(title)
      puts "Created clip id #{clip.id}"

      images.each do |image|
        new_frame = authenticated_client.create_frame(clip.id)
        file_upload = Faraday::UploadIO.new(image, 'image/jpeg')
        params = new_frame.upload_params.to_hash.merge({'file' => file_upload })

        conn = Faraday.new do |c|
          c.use Faraday::Request::Multipart
          c.adapter :net_http
        end
        response = conn.post(new_frame.upload_url, params)

        if response.status == 303
          conn.head response.headers['location']
        end

        authenticated_client.accept_frame(clip.id, new_frame.id)
        puts "Uploaded frame #{new_frame.id}"
      end

      sleep 2

      p authenticated_client.publish_clip(clip.id)

      puts clip.slug

    end


    protected

    def unauthenticated_client
      Lapse::Client.new(:api_scheme => 'http')
    end

    def authenticated_client
      raise unless access_token
      Lapse::Client.new(access_token)
    end

    def access_token
      @app_token ||= File.open(File.expand_path('~/.lapse')).read
    end

    def access_token=(val)
      @app_token = val
      File.open(File.expand_path('~/.lapse'), 'w+') do |f|
        f.write(val)
      end
      @app_token
    end
  end
end
