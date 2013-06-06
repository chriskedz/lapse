require 'thor'
require 'faraday'
require 'faraday_middleware'
require 'addressable/uri'
require 'yaml'

module Lapse
  class Cli < Thor
    desc 'signin', 'Signs the user in by passing in a twitter token'
    def signin(host, token)
      result = unauthenticated_client(host).authenticate(token)

      self.auth_data = {
        :access_token => result['access_token'],
        :api_host => host
      }

      result = ["Signed in as #{result.user.username}"]
      result << " on #{host}" if host
      puts result.join('')
    end

    desc 'signout', 'Signs the user out'
    def signout
      File.delete config_file
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

    def unauthenticated_client(host = api_host)
      options = {}.merge(server_options(host))
      Lapse::Client.new(options)
    end

    def authenticated_client(host = api_host)
      options = {:access_token => access_token}.merge(server_options(host))
      Lapse::Client.new(options)
    end

    def server_options(host)
      if host
        uri = Addressable::URI.parse(host)
        {:api_scheme => uri.scheme, :api_host => [uri.host, uri.port].compact.join(':')}
      else
        {}
      end
    end

    def access_token
      auth_data[:access_token]
    end

    def api_host
      auth_data[:api_host]
    end

    def auth_data
      @app_token ||= begin
        if File.exist?(config_file)
          YAML.load(File.open(config_file).read)
        else
          {}
        end
      end
    end

    def auth_data=(val)
      @app_token = val
      File.open(config_file, 'w+') do |f|
        f.write(YAML.dump(val))
      end
      @app_token
    end

    def config_file
      File.expand_path('~/.lapse')
    end
  end
end
